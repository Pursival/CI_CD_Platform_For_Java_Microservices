#!/bin/bash

echo "========================================="
echo "Testing Microservices"
echo "========================================="

# Get Minikube IP
MINIKUBE_IP=$(minikube ip)
echo "Minikube IP: $MINIKUBE_IP"
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test Auth Service
echo "Testing Auth Service..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://$MINIKUBE_IP:30081/api/auth/health)
if [ "$RESPONSE" -eq 200 ]; then
    echo -e "${GREEN}✓ Auth Service is UP${NC}"
else
    echo -e "${RED}✗ Auth Service is DOWN (HTTP $RESPONSE)${NC}"
fi

# Test Payment Service
echo "Testing Payment Service..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://$MINIKUBE_IP:30082/api/payment/health)
if [ "$RESPONSE" -eq 200 ]; then
    echo -e "${GREEN}✓ Payment Service is UP${NC}"
else
    echo -e "${RED}✗ Payment Service is DOWN (HTTP $RESPONSE)${NC}"
fi

# Test Balance Service
echo "Testing Balance Service..."
RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://$MINIKUBE_IP:30083/api/balance/health)
if [ "$RESPONSE" -eq 200 ]; then
    echo -e "${GREEN}✓ Balance Service is UP${NC}"
else
    echo -e "${RED}✗ Balance Service is DOWN (HTTP $RESPONSE)${NC}"
fi

echo ""
echo "========================================="
echo "Integration Test Flow"
echo "========================================="

# 1. Login
echo "1. Testing login..."
LOGIN_RESPONSE=$(curl -s -X POST http://$MINIKUBE_IP:30081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"test123"}')

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -n "$TOKEN" ]; then
    echo -e "${GREEN}✓ Login successful. Token: ${TOKEN:0:20}...${NC}"
else
    echo -e "${RED}✗ Login failed${NC}"
    exit 1
fi

# 2. Create balance
echo "2. Creating balance..."
BALANCE_RESPONSE=$(curl -s -X POST http://$MINIKUBE_IP:30083/api/balance/create?userId=testuser)
echo -e "${GREEN}✓ Balance created${NC}"

# 3. Check balance
echo "3. Checking balance..."
BALANCE=$(curl -s http://$MINIKUBE_IP:30083/api/balance/testuser)
echo "Balance: $BALANCE"

# 4. Process payment
echo "4. Processing payment..."
PAYMENT_RESPONSE=$(curl -s -X POST http://$MINIKUBE_IP:30082/api/payment/process \
  -H "Content-Type: application/json" \
  -d '{"userId":"testuser","amount":50.0,"currency":"USD","description":"Integration test payment"}')
echo -e "${GREEN}✓ Payment processed${NC}"
echo "Payment: $PAYMENT_RESPONSE"

# 5. Check payment history
echo "5. Checking payment history..."
HISTORY=$(curl -s http://$MINIKUBE_IP:30082/api/payment/history/testuser)
echo "Payment History: $HISTORY"

echo ""
echo "========================================="
echo "All tests completed!"
echo "========================================="

