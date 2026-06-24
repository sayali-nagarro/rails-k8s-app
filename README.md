```
┌─────────────────────────────────────────────────────────────┐
│ Kubernetes Cluster │
│ │
│ ┌─────────────────────────────────────────────────────┐ │
│ │ Ingress (nginx) │ │
│ │ rails-app.local │ │
│ └──────────────────┬──────────────────────────────────┘ │
│ │ │
│ ┌──────────────────▼──────────────────────────────────┐ │
│ │ Rails Service (ClusterIP) │ │
│ │ Port: 80 -> 3000 │ │
│ └──────────────────┬──────────────────────────────────┘ │
│ │ │
│ ┌──────────────────▼──────────────────────────────────┐ │
│ │ Rails Deployment (4 replicas) │ │
│ │ API Tier │ │
│ │ - Rolling Updates │ │
│ │ - HPA (CPU/Memory) │ │
│ │ - Self-healing │ │
│ └──────────────────┬──────────────────────────────────┘ │
│ │ │
│ ┌──────────────────▼──────────────────────────────────┐ │
│ │ PostgreSQL Service (Headless) │ │
│ │ Port: 5432 │ │
│ └──────────────────┬──────────────────────────────────┘ │
│ │ │
│ ┌──────────────────▼──────────────────────────────────┐ │
│ │ PostgreSQL StatefulSet (1 replica) │ │
│ │ Database Tier │ │
│ │ - Persistent Storage │ │
│ │ - Auto-recovery │ │
│ └─────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘

```

## Features

### Service API Tier
- RESTful API endpoints for product management
- Health check and metrics endpoints
- Connection pooling with PostgreSQL
- Rolling updates support
- External accessibility via Ingress
- Self-healing capabilities
- Horizontal Pod Autoscaling (HPA)
- Configurable via ConfigMap
- Secrets management for sensitive data

### Database Tier
- PostgreSQL with persistent storage
- 10 sample product records
- Only accessible within cluster
- Automatic recovery after pod deletion
- Data persistence across deployments

## API Endpoints

### Public Endpoints
- `GET /health` - Health check
- `GET /metrics` - Application metrics for HPA
- `GET /api/v1/products` - List all products
- `GET /api/v1/products/:id` - Get specific product
- `GET /api/v1/products/available` - List available products
- `GET /api/v1/products/category/:category` - Products by category

### Admin Endpoints
- `POST /api/v1/products` - Create product
- `PUT /api/v1/products/:id` - Update product
- `DELETE /api/v1/products/:id` - Delete product

## Local Development

### Prerequisites
- Docker
- Docker Compose
- Ruby 3.3.6
- PostgreSQL 15

### Setup
```bash
# Clone repository
git clone <repository-url>
cd rails-k8s-app

# Install dependencies
bundle install

# Setup database
rails db:create
rails db:migrate
rails db:seed

# Run tests
bundle exec rspec

# Run with Docker Compose
docker-compose up --build
```

### Access Application

- API: http://localhost:3000/
- Health: http://localhost:3000/health

## Kubernetes Deployment

### Prerequisites

- Kubernetes cluster (minikube, kind, or cloud provider)
- kubectl configured
- Docker (for image building)
- Docker Hub account

### Build and Push Docker Image
```bash
# Build image
docker build -t yourusername/rails-k8s-app:latest .

# Push to Docker Hub
docker push yourusername/rails-k8s-app:latest
```

### Deploy to Kubernetes
```bash
# Update image in k8s/rails/deployment.yaml
# Replace 'yourusername/rails-k8s-app:latest' with your image

# Deploy all resources
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
kubectl apply -f k8s/postgres/statefulset.yaml
kubectl apply -f k8s/postgres/service.yaml
kubectl apply -f k8s/rails/deployment.yaml
kubectl apply -f k8s/rails/service.yaml
kubectl apply -f k8s/rails/hpa.yaml
kubectl apply -f k8s/ingress.yaml
kubectl apply -f k8s/network-policy.yaml
```

### Verify Deployment
```bash
# Check all pods
kubectl get pods -n rails-app

# Check services
kubectl get svc -n rails-app

# Check HPA
kubectl get hpa -n rails-app

# Check ingress
kubectl get ingress -n rails-app

# View logs
kubectl logs -f deployment/rails-app -n rails-app

# Test API
kubectl port-forward service/rails-service 8080:80 -n rails-app
curl http://localhost:8080/health
```

### Access via Ingress (Minikube)
```bash
# Enable ingress in minikube
minikube addons enable ingress

# Get ingress IP (minikube)
minikube ip

# Add to /etc/hosts
echo " rails-app.local" | sudo tee -a /etc/hosts

# Access the application
curl http://rails-app.local/health
```

## Resource Optimization

### Current Resource Configuration
```yaml
Resources:
  requests:
    memory: 256Mi
    cpu: 250m
  limits:
    memory: 512Mi
    cpu: 500m
```

### Cost Optimization Opportunities

1. **Right-sizing Resources** Monitor actual usage with metrics-server
2. Adjust requests/limits based on real usage patterns
3. Use vertical pod autoscaling (VPA) for recommendations
4. **Auto-scaling Optimization** Fine-tune HPA thresholds based on application behavior
5. Consider custom metrics for better scaling decisions
6. Implement pod disruption budgets for cost control
7. **Resource Utilization** Implement resource quotas per namespace
8. Use spot instances for non-critical workloads
9. Implement cluster autoscaling for demand-based scaling

## Monitoring

### Prometheus Metrics
The application exposes metrics at `/metrics` endpoint:

- Product count
- Active product count
- Total stock quantity
- Request timestamps

### Health Checks

- Liveness Probe: `/health` (30s initial delay)
- Readiness Probe: `/health` (10s initial delay)
- Startup Probe: `/health` (60s initial delay)

## Troubleshooting

### Common Issues

1. **Database Connection Issues**
```bash
# Check PostgreSQL pod status
kubectl get pods -n rails-app -l app=postgres

# Check PostgreSQL logs
kubectl logs -f postgres-0 -n rails-app
```
2. **Migration Failures**
```bash
# View Rails logs
kubectl logs -f deployment/rails-app -n rails-app
```
3. **HPA Not Scaling**
```bash
# Check HPA status
kubectl describe hpa rails-app-hpa -n rails-app

# Check metrics-server
kubectl get pods -n kube-system | grep metrics-server
```

## Performance Testing

### Load Test Script
```bash
#!/bin/bash
# Run 1000 concurrent requests
for i in {1..1000}; do
  curl -s http://localhost:3000/api/v1/products &
done
wait
```

## Security Best Practices

1. **Secrets Management** — All sensitive data stored in Kubernetes Secrets
2. Never commit secrets to version control
3. Use external secret management (Vault) in production
4. **Network Security** — Network policies restrict database access
5. Only API tier can access database
6. Internal services not exposed externally
7. **Container Security** — Run containers as non-root users
8. Use minimal base images (Alpine) where possible
9. Apply regular security updates and image scanning

## Troubleshooting HPA

### Check HPA Status
```bash
kubectl describe hpa rails-app-hpa -n rails-app
```

### Verify Metrics Server
```bash
kubectl top pods -n rails-app
```

### Manual Scaling
```bash
kubectl scale deployment rails-app -n rails-app --replicas=6
```

## License

MIT

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## Additional Helper Scripts

Create a simple deployment helper:

```bash
# Create a deployment script (example)
cat > deploy.sh <<'EOF'
#!/bin/bash
kubectl apply -f k8s/
EOF
chmod +x deploy.sh
```

## Final Verification Commands
```bash
# Check all files are created
ls -la

# Verify Ruby version
ruby -v

# Verify Rails version
rails -v

# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Run tests
bundle exec rspec

# Start local server
rails server -b 0.0.0.0

# Test API locally
curl http://localhost:3000/health
curl http://localhost:3000/api/v1/products
```

## Quick Reference Commands

### Docker Commands
```bash
# Build image
docker build -t yourusername/rails-k8s-app:latest .

# Run container
docker run -p 3000:3000 yourusername/rails-k8s-app:latest

# Push to registry
docker push yourusername/rails-k8s-app:latest
```

### Kubernetes Commands
```bash
# Apply all resources
kubectl apply -f k8s/

# Delete all resources
kubectl delete -f k8s/

# Get pods
kubectl get pods -n rails-app -w

# Port forward
kubectl port-forward service/rails-service 8080:80 -n rails-app

# Scale manually
kubectl scale deployment rails-app -n rails-app --replicas=6
```

