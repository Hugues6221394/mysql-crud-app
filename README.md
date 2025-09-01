# MySQL CRUD Application

A full-stack application with MySQL, Node.js/Express backend, and React frontend, containerized with Docker and deployable to Kubernetes.

## Features

- Create, Read, Update, Delete (CRUD) operations on items
- MySQL database with sample data
- Node.js/Express REST API
- React frontend with Vite
- Docker containerization
- Kubernetes deployment manifests
- GitHub Actions CI/CD pipelines

Here’s a cleanly aligned version you can drop into your README:

## Project Structure

```

mysql-crud-app/
├── .github/workflows/     # GitHub Actions workflows
├── backend/              # Node.js/Express API
├── frontend/             # React application
├── k8s/                  # Kubernetes manifests
├── mariadb/              # Database initialization scripts
├── nginx/                # NGINX configuration
├── docker-compose.yml    # Production compose file
├── docker-compose.dev.yml# Development compose file
└── .env                  # Environment variables

```

## Quick Start

### Development with Docker Compose

1. Clone the repository
2. Run `docker-compose -f docker-compose.dev.yml up --build`
3. Access the application at http://localhost:5173

### Production Deployment with Docker Compose

1. Set environment variables in `.env`
2. Build and push images to your registry
3. Run `docker-compose up -d`

### Kubernetes Deployment

1. Apply secrets: `kubectl apply -f k8s/mariadb-secret.yaml -f k8s/backend-secret.yaml`
2. Apply configmaps: `kubectl apply -f k8s/mariadb-init-configmap.yaml -f k8s/frontend-configmap.yaml`
3. Apply PVC: `kubectl apply -f k8s/mariadb-pvc.yaml`
4. Apply deployments and services: `kubectl apply -f k8s/`

## Environment Variables

- `DB_ROOT_PASSWORD`: MySQL root password
- `DB_USER`: MySQL application user
- `DB_PASSWORD`: MySQL application user password
- `DB_NAME`: MySQL database name
- `BACKEND_IMAGE`: Backend Docker image name
- `FRONTEND_IMAGE`: Frontend Docker image name

## API Endpoints

- `GET /api/health` - Health check
- `GET /api/items` - Get all items
- `GET /api/items/:id` - Get single item
- `POST /api/items` - Create new item
- `PUT /api/items/:id` - Update item
- `DELETE /api/items/:id` - Delete item

