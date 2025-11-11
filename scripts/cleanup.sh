#!/bin/bash

echo "========================================="
echo "Cleanup Script"
echo "========================================="

read -p "This will delete all deployments and services. Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cleanup cancelled."
    exit 1
fi

echo "Deleting Kubernetes resources..."
kubectl delete -f kubernetes/ingress.yaml --ignore-not-found=true
kubectl delete -f kubernetes/balance-service-service.yaml --ignore-not-found=true
kubectl delete -f kubernetes/balance-service-deployment.yaml --ignore-not-found=true
kubectl delete -f kubernetes/payment-service-service.yaml --ignore-not-found=true
kubectl delete -f kubernetes/payment-service-deployment.yaml --ignore-not-found=true
kubectl delete -f kubernetes/auth-service-service.yaml --ignore-not-found=true
kubectl delete -f kubernetes/auth-service-deployment.yaml --ignore-not-found=true

echo "Cleanup completed!"
echo ""
echo "To restart from scratch:"
echo "  minikube delete"
echo "  docker-compose down -v"
echo ""

