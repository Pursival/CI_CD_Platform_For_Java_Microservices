# PowerShell script for Windows - Minikube Setup

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Minikube Setup Script (Windows)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Minikube is installed
if (!(Get-Command minikube -ErrorAction SilentlyContinue)) {
    Write-Host "Minikube is not installed. Please install it first." -ForegroundColor Red
    Write-Host "Visit: https://minikube.sigs.k8s.io/docs/start/" -ForegroundColor Yellow
    exit 1
}

# Check if kubectl is installed
if (!(Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Host "kubectl is not installed. Please install it first." -ForegroundColor Red
    Write-Host "Visit: https://kubernetes.io/docs/tasks/tools/" -ForegroundColor Yellow
    exit 1
}

# Start Minikube
Write-Host "Starting Minikube..." -ForegroundColor Green
minikube start --driver=docker --cpus=4 --memory=8192

# Wait for Minikube to be ready
Write-Host "Waiting for Minikube to be ready..." -ForegroundColor Green
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Enable Ingress addon
Write-Host "Enabling Ingress addon..." -ForegroundColor Green
minikube addons enable ingress

# Configure insecure registry for local Docker registry
Write-Host "Configuring insecure registry..." -ForegroundColor Green
minikube ssh "echo '{`"insecure-registries`": [`"localhost:5000`", `"host.minikube.internal:5000`"]}' | sudo tee /etc/docker/daemon.json"
minikube ssh "sudo systemctl restart docker"

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Minikube is ready!" -ForegroundColor Green
$minikubeIp = minikube ip
Write-Host "Minikube IP: $minikubeIp" -ForegroundColor Yellow
Write-Host ""
Write-Host "To access services:" -ForegroundColor Cyan
Write-Host "  kubectl get services"
Write-Host "  kubectl get pods"
Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan

