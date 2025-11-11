#!/bin/bash

echo "========================================="
echo "CI/CD Platform Status Check"
echo "========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check Docker
echo "1. Docker Status:"
if command -v docker &> /dev/null; then
    if docker ps &> /dev/null; then
        echo -e "${GREEN}✓ Docker is running${NC}"
        echo "  Running containers: $(docker ps -q | wc -l)"
    else
        echo -e "${RED}✗ Docker is not running${NC}"
    fi
else
    echo -e "${RED}✗ Docker is not installed${NC}"
fi
echo ""

# Check Docker Compose services
echo "2. Docker Compose Services:"
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✓ Docker Compose services are running${NC}"
    docker-compose ps
else
    echo -e "${YELLOW}! Docker Compose services are not running${NC}"
    echo "  Run: docker-compose up -d"
fi
echo ""

# Check Minikube
echo "3. Minikube Status:"
if command -v minikube &> /dev/null; then
    STATUS=$(minikube status --format='{{.Host}}' 2>/dev/null)
    if [ "$STATUS" == "Running" ]; then
        echo -e "${GREEN}✓ Minikube is running${NC}"
        echo "  IP: $(minikube ip)"
        echo "  Version: $(minikube version --short)"
    else
        echo -e "${RED}✗ Minikube is not running${NC}"
        echo "  Run: minikube start"
    fi
else
    echo -e "${RED}✗ Minikube is not installed${NC}"
fi
echo ""

# Check kubectl
echo "4. Kubernetes Cluster:"
if command -v kubectl &> /dev/null; then
    if kubectl cluster-info &> /dev/null; then
        echo -e "${GREEN}✓ Kubernetes cluster is accessible${NC}"
        echo ""
        echo "  Deployments:"
        kubectl get deployments 2>/dev/null | grep -E "NAME|service" || echo "  No deployments found"
        echo ""
        echo "  Pods:"
        kubectl get pods 2>/dev/null | grep -E "NAME|service" || echo "  No pods found"
        echo ""
        echo "  Services:"
        kubectl get services 2>/dev/null | grep -E "NAME|service" || echo "  No services found"
    else
        echo -e "${RED}✗ Cannot connect to Kubernetes cluster${NC}"
    fi
else
    echo -e "${RED}✗ kubectl is not installed${NC}"
fi
echo ""

# Check Jenkins
echo "5. Jenkins:"
JENKINS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 2>/dev/null)
if [ "$JENKINS_STATUS" -eq 200 ] || [ "$JENKINS_STATUS" -eq 403 ]; then
    echo -e "${GREEN}✓ Jenkins is accessible at http://localhost:8080${NC}"
else
    echo -e "${RED}✗ Jenkins is not accessible${NC}"
    echo "  Run: docker-compose up -d jenkins"
fi
echo ""

# Check Docker Registry
echo "6. Docker Registry:"
REGISTRY_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:5000/v2/_catalog 2>/dev/null)
if [ "$REGISTRY_STATUS" -eq 200 ]; then
    echo -e "${GREEN}✓ Docker Registry is accessible at http://localhost:5000${NC}"
    echo "  Registry UI: http://localhost:8081"
    IMAGES=$(curl -s http://localhost:5000/v2/_catalog 2>/dev/null)
    echo "  Images: $IMAGES"
else
    echo -e "${RED}✗ Docker Registry is not accessible${NC}"
    echo "  Run: docker-compose up -d registry"
fi
echo ""

# Check SonarQube
echo "7. SonarQube:"
SONAR_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:9000 2>/dev/null)
if [ "$SONAR_STATUS" -eq 200 ]; then
    echo -e "${GREEN}✓ SonarQube is accessible at http://localhost:9000${NC}"
else
    echo -e "${YELLOW}! SonarQube is not accessible (optional service)${NC}"
fi
echo ""

# Summary
echo "========================================="
echo "Summary"
echo "========================================="
echo ""
echo "Next steps:"
echo "1. If any service is not running, start it with the appropriate command"
echo "2. Deploy microservices: ./scripts/deploy-all.sh"
echo "3. Test services: ./scripts/test-services.sh"
echo "4. Access Jenkins: http://localhost:8080"
echo "5. Access services via NodePort:"
echo "   - Auth: http://\$(minikube ip):30081/api/auth/health"
echo "   - Payment: http://\$(minikube ip):30082/api/payment/health"
echo "   - Balance: http://\$(minikube ip):30083/api/balance/health"
echo ""

