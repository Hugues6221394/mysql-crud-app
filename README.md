# MySQL CRUD Application

![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)
![Node.js](https://img.shields.io/badge/Node.js-43853D?logo=node.js&logoColor=white)
![Express](https://img.shields.io/badge/Express.js-000000?logo=express&logoColor=white)
![React](https://img.shields.io/badge/React-61DAFB?logo=react&logoColor=black)
![MySQL](https://img.shields.io/badge/MySQL-4479A1?logo=mysql&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)

A full-stack application with a MySQL database, Node.js/Express backend, and React frontend.  
The project is fully containerized with Docker and includes deployment manifests for Kubernetes.

## Features

- Full CRUD (Create, Read, Update, Delete) operations
- MySQL database with sample data
- REST API built with Node.js/Express
- React frontend powered by Vite
- Docker containerization for local and production
- Kubernetes manifests for cloud deployment
- GitHub Actions workflows for CI/CD

## Project Structure

```

mysql-crud-app/
├── .github/workflows/      # GitHub Actions workflows
├── backend/                # Node.js/Express API
├── frontend/               # React application
├── k8s/                    # Kubernetes manifests
├── mariadb/                # Database initialization scripts
├── nginx/                  # NGINX configuration
├── docker-compose.yml      # Production compose file
├── docker-compose.dev.yml  # Development compose file
└── .env                    # Environment variables

````

## Quick Start

### Development (Docker Compose)

1. Clone the repository  
2. Run:  
   ```bash
   docker-compose -f docker-compose.dev.yml up --build
````

3. Open the app at [http://localhost:5173](http://localhost:5173)

### Production (Docker Compose)

1. Configure environment variables in `.env`
2. Build and push images to your container registry
3. Deploy with:

   ```bash
   docker-compose up -d
   ```

### Kubernetes Deployment

1. Apply secrets:

   ```bash
   kubectl apply -f k8s/mariadb-secret.yaml -f k8s/backend-secret.yaml
   ```
2. Apply configmaps:

   ```bash
   kubectl apply -f k8s/mariadb-init-configmap.yaml -f k8s/frontend-configmap.yaml
   ```
3. Apply persistent volume claim:

   ```bash
   kubectl apply -f k8s/mariadb-pvc.yaml
   ```
4. Deploy workloads and services:

   ```bash
   kubectl apply -f k8s/
   ```

## Environment Variables

| Variable           | Description                       |
| ------------------ | --------------------------------- |
| `DB_ROOT_PASSWORD` | MySQL root password               |
| `DB_USER`          | MySQL application user            |
| `DB_PASSWORD`      | Password for the application user |
| `DB_NAME`          | MySQL database name               |
| `BACKEND_IMAGE`    | Docker image for backend          |
| `FRONTEND_IMAGE`   | Docker image for frontend         |

## API Endpoints

* `GET /api/health` → Health check
* `GET /api/items` → Fetch all items
* `GET /api/items/:id` → Fetch single item
* `POST /api/items` → Create new item
* `PUT /api/items/:id` → Update item
* `DELETE /api/items/:id` → Delete item
