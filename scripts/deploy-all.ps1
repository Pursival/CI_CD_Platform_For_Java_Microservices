# PowerShell script for Windows - Deploy All Microservices

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Deploy All Microservices" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Set variables
$REGISTRY = "localhost:5000"
$SERVICES = @("auth-service", "payment-service", "balance-service")

# Build and push all services
foreach ($SERVICE in $SERVICES) {
    Write-Host ""
    Write-Host "Processing $SERVICE..." -ForegroundColor Green
    Write-Host "------------------------" -ForegroundColor Gray
    
    # Navigate to service directory
    Set-Location "microservices\$SERVICE"
    
    # Build with Maven
    Write-Host "Building $SERVICE with Maven..." -ForegroundColor Yellow
    mvn clean package -DskipTests
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Maven build failed for $SERVICE" -ForegroundColor Red
        exit 1
    }
    
    # Build Docker image
    Write-Host "Building Docker image for $SERVICE..." -ForegroundColor Yellow
    docker build -t "$REGISTRY/${SERVICE}:latest" .
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Docker build failed for $SERVICE" -ForegroundColor Red
        exit 1
    }
    
    # Push to local registry
    Write-Host "Pushing $SERVICE to registry..." -ForegroundColor Yellow
    docker push "$REGISTRY/${SERVICE}:latest"
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Docker push failed for $SERVICE" -ForegroundColor Red
        exit 1
    }
    
    # Return to root directory
    Set-Location ..\..
    
    Write-Host "$SERVICE processed successfully!" -ForegroundColor Green
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Deploying to Kubernetes..." -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Apply Kubernetes configurations
kubectl apply -f kubernetes/namespace.yaml
kubectl apply -f kubernetes/auth-service-deployment.yaml
kubectl apply -f kubernetes/auth-service-service.yaml
kubectl apply -f kubernetes/payment-service-deployment.yaml
kubectl apply -f kubernetes/payment-service-service.yaml
kubectl apply -f kubernetes/balance-service-deployment.yaml
kubectl apply -f kubernetes/balance-service-service.yaml
kubectl apply -f kubernetes/ingress.yaml

# Wait for deployments to be ready
Write-Host ""
Write-Host "Waiting for deployments to be ready..." -ForegroundColor Yellow
kubectl rollout status deployment/auth-service --timeout=300s
kubectl rollout status deployment/payment-service --timeout=300s
kubectl rollout status deployment/balance-service --timeout=300s

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Deployment completed!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services are accessible at:" -ForegroundColor Cyan
$MINIKUBE_IP = minikube ip
Write-Host "Auth Service:    http://${MINIKUBE_IP}:30081/api/auth/health" -ForegroundColor Yellow
Write-Host "Payment Service: http://${MINIKUBE_IP}:30082/api/payment/health" -ForegroundColor Yellow
Write-Host "Balance Service: http://${MINIKUBE_IP}:30083/api/balance/health" -ForegroundColor Yellow
Write-Host ""
Write-Host "Check status with:" -ForegroundColor Cyan
Write-Host "  kubectl get pods"
Write-Host "  kubectl get services"
Write-Host ""

