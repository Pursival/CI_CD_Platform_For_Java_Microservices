#!/bin/bash

echo "========================================="
echo "Minikube Setup Script"
echo "========================================="

# Check if Minikube is installed
if ! command -v minikube &> /dev/null; then
    echo "Minikube is not installed. Please install it first."
    echo "Visit: https://minikube.sigs.k8s.io/docs/start/"
    exit 1
fi

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Please install it first."
    echo "Visit: https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

# Start Minikube
echo "Starting Minikube..."
minikube start --driver=docker --cpus=4 --memory=8192

# Wait for Minikube to be ready
echo "Waiting for Minikube to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Enable Ingress addon
echo "Enabling Ingress addon..."
minikube addons enable ingress

# Configure Docker to use Minikube's Docker daemon
echo ""
echo "========================================="
echo "To use Minikube's Docker daemon, run:"
echo "eval \$(minikube docker-env)"
echo "========================================="
echo ""

# Configure insecure registry for local Docker registry
echo "Configuring insecure registry..."
minikube ssh "echo '{\"insecure-registries\": [\"localhost:5000\", \"host.minikube.internal:5000\"]}' | sudo tee /etc/docker/daemon.json"
minikube ssh "sudo systemctl restart docker"

echo ""
echo "Minikube is ready!"
echo "Minikube IP: $(minikube ip)"
echo ""
echo "To access services:"
echo "  kubectl get services"
echo "  kubectl get pods"
echo ""

