# PowerShell script for Windows - Cleanup

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Cleanup Script" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

$confirmation = Read-Host "This will delete all deployments and services. Continue? (y/n)"
if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    Write-Host "Cleanup cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host "Deleting Kubernetes resources..." -ForegroundColor Yellow

kubectl delete -f kubernetes/ingress.yaml --ignore-not-found=true
kubectl delete -f kubernetes/balance-service-service.yaml --ignore-not-found=true
kubectl delete -f kubernetes/balance-service-deployment.yaml --ignore-not-found=true
kubectl delete -f kubernetes/payment-service-service.yaml --ignore-not-found=true
kubectl delete -f kubernetes/payment-service-deployment.yaml --ignore-not-found=true
kubectl delete -f kubernetes/auth-service-service.yaml --ignore-not-found=true
kubectl delete -f kubernetes/auth-service-deployment.yaml --ignore-not-found=true

Write-Host ""
Write-Host "Cleanup completed!" -ForegroundColor Green
Write-Host ""
Write-Host "To restart from scratch:" -ForegroundColor Cyan
Write-Host "  minikube delete"
Write-Host "  docker-compose down -v"
Write-Host ""

