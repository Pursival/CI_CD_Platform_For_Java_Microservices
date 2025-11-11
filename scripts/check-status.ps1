# PowerShell script for Windows - Check Platform Status

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "CI/CD Platform Status Check" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Check Docker
Write-Host "1. Docker Status:" -ForegroundColor Cyan
try {
    docker ps | Out-Null
    Write-Host "[OK] Docker is running" -ForegroundColor Green
    $containerCount = (docker ps -q).Count
    Write-Host "  Running containers: $containerCount" -ForegroundColor Gray
} catch {
    Write-Host "[FAIL] Docker is not running" -ForegroundColor Red
}
Write-Host ""

# Check Docker Compose services
Write-Host "2. Docker Compose Services:" -ForegroundColor Cyan
try {
    $composeOutput = docker-compose ps
    if ($composeOutput -match "Up") {
        Write-Host "[OK] Docker Compose services are running" -ForegroundColor Green
        docker-compose ps
    } else {
        Write-Host "[WARN] Docker Compose services are not running" -ForegroundColor Yellow
        Write-Host "  Run: docker-compose up -d" -ForegroundColor Gray
    }
} catch {
    Write-Host "[WARN] Docker Compose services are not running" -ForegroundColor Yellow
    Write-Host "  Run: docker-compose up -d" -ForegroundColor Gray
}
Write-Host ""

# Check Minikube
Write-Host "3. Minikube Status:" -ForegroundColor Cyan
try {
    $minikubeStatus = minikube status --format='{{.Host}}' 2>$null
    if ($minikubeStatus -eq "Running") {
        Write-Host "[OK] Minikube is running" -ForegroundColor Green
        $minikubeIp = minikube ip
        Write-Host "  IP: $minikubeIp" -ForegroundColor Gray
        $minikubeVersion = minikube version --short
        Write-Host "  Version: $minikubeVersion" -ForegroundColor Gray
    } else {
        Write-Host "[FAIL] Minikube is not running" -ForegroundColor Red
        Write-Host "  Run: minikube start" -ForegroundColor Gray
    }
} catch {
    Write-Host "[FAIL] Minikube is not installed or not running" -ForegroundColor Red
}
Write-Host ""

# Check kubectl
Write-Host "4. Kubernetes Cluster:" -ForegroundColor Cyan
try {
    kubectl cluster-info 2>$null | Out-Null
    Write-Host "[OK] Kubernetes cluster is accessible" -ForegroundColor Green
    Write-Host ""
    Write-Host "  Deployments:" -ForegroundColor Gray
    kubectl get deployments 2>$null | Select-String -Pattern "NAME|service"
    Write-Host ""
    Write-Host "  Pods:" -ForegroundColor Gray
    kubectl get pods 2>$null | Select-String -Pattern "NAME|service"
    Write-Host ""
    Write-Host "  Services:" -ForegroundColor Gray
    kubectl get services 2>$null | Select-String -Pattern "NAME|service"
} catch {
    Write-Host "[FAIL] Cannot connect to Kubernetes cluster" -ForegroundColor Red
}
Write-Host ""

# Check Jenkins
Write-Host "5. Jenkins:" -ForegroundColor Cyan
try {
    $jenkinsResponse = Invoke-WebRequest -Uri "http://localhost:8080" -Method GET -UseBasicParsing -TimeoutSec 5
    if ($jenkinsResponse.StatusCode -in @(200, 403)) {
        Write-Host "[OK] Jenkins is accessible at http://localhost:8080" -ForegroundColor Green
    }
} catch {
    Write-Host "[FAIL] Jenkins is not accessible" -ForegroundColor Red
    Write-Host "  Run: docker-compose up -d jenkins" -ForegroundColor Gray
}
Write-Host ""

# Check Docker Registry
Write-Host "6. Docker Registry:" -ForegroundColor Cyan
try {
    $registryResponse = Invoke-RestMethod -Uri "http://localhost:5000/v2/_catalog" -Method GET
    Write-Host "[OK] Docker Registry is accessible at http://localhost:5000" -ForegroundColor Green
    Write-Host "  Registry UI: http://localhost:8081" -ForegroundColor Gray
    Write-Host "  Images: $($registryResponse | ConvertTo-Json -Compress)" -ForegroundColor Gray
} catch {
    Write-Host "[FAIL] Docker Registry is not accessible" -ForegroundColor Red
    Write-Host "  Run: docker-compose up -d registry" -ForegroundColor Gray
}
Write-Host ""

# Check SonarQube
Write-Host "7. SonarQube:" -ForegroundColor Cyan
try {
    $sonarResponse = Invoke-WebRequest -Uri "http://localhost:9000" -Method GET -UseBasicParsing -TimeoutSec 5
    if ($sonarResponse.StatusCode -eq 200) {
        Write-Host "[OK] SonarQube is accessible at http://localhost:9000" -ForegroundColor Green
    }
} catch {
    Write-Host "[WARN] SonarQube is not accessible (optional service)" -ForegroundColor Yellow
}
Write-Host ""

# Summary
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. If any service is not running, start it with the appropriate command"
Write-Host "2. Deploy microservices: .\scripts\deploy-all.ps1"
Write-Host "3. Test services: .\scripts\test-services.ps1"
Write-Host "4. Access Jenkins: http://localhost:8080"
Write-Host "5. Access services via NodePort:"
$minikubeIp = minikube ip 2>$null
if ($minikubeIp) {
    Write-Host "   - Auth: http://${minikubeIp}:30081/api/auth/health"
    Write-Host "   - Payment: http://${minikubeIp}:30082/api/payment/health"
    Write-Host "   - Balance: http://${minikubeIp}:30083/api/balance/health"
}
Write-Host ""

