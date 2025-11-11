# PowerShell script for Windows - Test Microservices

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Testing Microservices" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Get Minikube IP
$MINIKUBE_IP = minikube ip
Write-Host "Minikube IP: $MINIKUBE_IP" -ForegroundColor Yellow
Write-Host ""

# Test Auth Service
Write-Host "Testing Auth Service..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://${MINIKUBE_IP}:30081/api/auth/health" -Method GET -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Auth Service is UP" -ForegroundColor Green
    }
} catch {
    Write-Host "[FAIL] Auth Service is DOWN" -ForegroundColor Red
}

# Test Payment Service
Write-Host "Testing Payment Service..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://${MINIKUBE_IP}:30082/api/payment/health" -Method GET -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Payment Service is UP" -ForegroundColor Green
    }
} catch {
    Write-Host "[FAIL] Payment Service is DOWN" -ForegroundColor Red
}

# Test Balance Service
Write-Host "Testing Balance Service..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://${MINIKUBE_IP}:30083/api/balance/health" -Method GET -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "[OK] Balance Service is UP" -ForegroundColor Green
    }
} catch {
    Write-Host "[FAIL] Balance Service is DOWN" -ForegroundColor Red
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Integration Test Flow" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# 1. Login
Write-Host "1. Testing login..." -ForegroundColor Yellow
$loginBody = @{
    username = "testuser"
    password = "test123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://${MINIKUBE_IP}:30081/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json"
    $token = $loginResponse.token
    
    if ($token) {
        Write-Host "[OK] Login successful. Token: $($token.Substring(0, 20))..." -ForegroundColor Green
    } else {
        Write-Host "[FAIL] Login failed - no token received" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "[FAIL] Login failed: $_" -ForegroundColor Red
    exit 1
}

# 2. Create balance
Write-Host "2. Creating balance..." -ForegroundColor Yellow
try {
    $balanceResponse = Invoke-RestMethod -Uri "http://${MINIKUBE_IP}:30083/api/balance/create?userId=testuser" -Method POST
    Write-Host "[OK] Balance created" -ForegroundColor Green
} catch {
    Write-Host "[FAIL] Balance creation failed: $_" -ForegroundColor Red
}

# 3. Check balance
Write-Host "3. Checking balance..." -ForegroundColor Yellow
try {
    $balance = Invoke-RestMethod -Uri "http://${MINIKUBE_IP}:30083/api/balance/testuser" -Method GET
    Write-Host "Balance: $($balance | ConvertTo-Json)" -ForegroundColor Cyan
} catch {
    Write-Host "[FAIL] Failed to get balance: $_" -ForegroundColor Red
}

# 4. Process payment
Write-Host "4. Processing payment..." -ForegroundColor Yellow
$paymentBody = @{
    userId = "testuser"
    amount = 50.0
    currency = "USD"
    description = "Integration test payment"
} | ConvertTo-Json

try {
    $paymentResponse = Invoke-RestMethod -Uri "http://${MINIKUBE_IP}:30082/api/payment/process" -Method POST -Body $paymentBody -ContentType "application/json"
    Write-Host "[OK] Payment processed" -ForegroundColor Green
    Write-Host "Payment: $($paymentResponse | ConvertTo-Json)" -ForegroundColor Cyan
} catch {
    Write-Host "[FAIL] Payment processing failed: $_" -ForegroundColor Red
}

# 5. Check payment history
Write-Host "5. Checking payment history..." -ForegroundColor Yellow
try {
    $history = Invoke-RestMethod -Uri "http://${MINIKUBE_IP}:30082/api/payment/history/testuser" -Method GET
    Write-Host "Payment History: $($history | ConvertTo-Json)" -ForegroundColor Cyan
} catch {
    Write-Host "[FAIL] Failed to get payment history: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "All tests completed!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan

