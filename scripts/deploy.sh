#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required commands are available
check_requirements() {
    local commands=("docker" "docker-compose" "kubectl")
    for cmd in "${commands[@]}"; do
        if ! command -v $cmd &> /dev/null; then
            print_error "$cmd is not installed. Please install it to continue."
            exit 1
        fi
    done
    print_status "All requirements are satisfied."
}

# Build and push Docker images
build_images() {
    print_status "Building Docker images..."
    docker-compose -f docker-compose.dev.yml build
    
    if [ "$1" = "push" ]; then
        print_status "Pushing images to registry..."
        docker push $BACKEND_IMAGE
        docker push $FRONTEND_IMAGE
    fi
}

# Deploy to Docker Compose
deploy_compose() {
    print_status "Deploying with Docker Compose..."
    docker-compose up -d
    print_status "Application deployed successfully!"
    print_status "Frontend: http://localhost"
    print_status "API Health: http://localhost/api/health"
}

# Deploy to Kubernetes
deploy_kubernetes() {
    print_status "Deploying to Kubernetes..."
    
    # Apply secrets
    kubectl apply -f k8s/mariadb-secret.yaml
    kubectl apply -f k8s/backend-secret.yaml
    
    # Apply configmaps
    kubectl apply -f k8s/mariadb-init-configmap.yaml
    kubectl apply -f k8s/frontend-configmap.yaml
    
    # Apply PVC
    kubectl apply -f k8s/mariadb-pvc.yaml
    
    # Apply all other manifests
    kubectl apply -f k8s/
    
    print_status "Kubernetes deployment completed!"
    
    # Wait for services to be ready
    print_status "Waiting for services to be ready..."
    sleep 10
    
    # Get frontend service URL
    if kubectl get svc frontend -o jsonpath='{.spec.type}' | grep -q "LoadBalancer"; then
        print_status "Waiting for LoadBalancer IP..."
        while true; do
            IP=$(kubectl get svc frontend -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
            if [ -n "$IP" ]; then
                print_status "Frontend available at: http://$IP"
                break
            fi
            sleep 5
        done
    else
        print_status "To access the application, use port forwarding:"
        print_status "kubectl port-forward svc/frontend 8080:80"
        print_status "Then open: http://localhost:8080"
    fi
}

# Main execution
main() {
    check_requirements
    
    # Load environment variables
    if [ -f .env ]; then
        export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
    fi
    
    case "$1" in
        "build")
            build_images "$2"
            ;;
        "compose")
            deploy_compose
            ;;
        "kubernetes")
            deploy_kubernetes
            ;;
        "all")
            build_images
            deploy_kubernetes
            ;;
        *)
            echo "Usage: $0 {build [push]|compose|kubernetes|all}"
            echo "  build [push]   - Build Docker images (optionally push to registry)"
            echo "  compose        - Deploy using Docker Compose"
            echo "  kubernetes     - Deploy to Kubernetes"
            echo "  all            - Build and deploy to Kubernetes"
            exit 1
            ;;
    esac
}

# Run main function with arguments
main "$@"
