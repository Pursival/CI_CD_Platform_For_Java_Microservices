#!/bin/bash

echo "========================================="
echo "Deploy All Microservices"
echo "========================================="

# Set variables
REGISTRY="localhost:5000"
SERVICES=("auth-service" "payment-service" "balance-service")

# Build and push all services
for SERVICE in "${SERVICES[@]}"; do
    echo ""
    echo "Processing $SERVICE..."
    echo "------------------------"
    
    # Navigate to service directory
    cd "microservices/$SERVICE" || exit
    
    # Build with Maven
    echo "Building $SERVICE with Maven..."
    mvn clean package -DskipTests
    
    # Build Docker image
    echo "Building Docker image for $SERVICE..."
    docker build -t "$REGISTRY/$SERVICE:latest" .
    
    # Push to local registry
    echo "Pushing $SERVICE to registry..."
    docker push "$REGISTRY/$SERVICE:latest"
    
    # Return to root directory
    cd ../.. || exit
    
    echo "$SERVICE processed successfully!"
done

echo ""
echo "========================================="
echo "Deploying to Kubernetes..."
echo "========================================="

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
echo ""
echo "Waiting for deployments to be ready..."
kubectl rollout status deployment/auth-service --timeout=300s
kubectl rollout status deployment/payment-service --timeout=300s
kubectl rollout status deployment/balance-service --timeout=300s

echo ""
echo "========================================="
echo "Deployment completed!"
echo "========================================="
echo ""
echo "Services are accessible at:"
MINIKUBE_IP=$(minikube ip)
echo "Auth Service:    http://$MINIKUBE_IP:30081/api/auth/health"
echo "Payment Service: http://$MINIKUBE_IP:30082/api/payment/health"
echo "Balance Service: http://$MINIKUBE_IP:30083/api/balance/health"
echo ""
echo "Check status with:"
echo "  kubectl get pods"
echo "  kubectl get services"
echo ""

