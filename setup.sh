#!/bin/bash

set -e

echo "Starting Kubernetes setup..."

kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "Applying Tigera Operator (Calico)..."
kubectl apply -f tigera-operator.yaml

echo "Applying Calico custom resources..."
kubectl apply -f calico-custom-resources.yaml

echo "Applying MetalLB resources..."
kubectl apply -f metallb-namespace.yaml
kubectl apply -f metallb.yaml
kubectl apply -f metallb-config-pool.yaml

echo "Applying Nginx Ingress Controller..."
kubectl apply -f ingress-nginx.yaml

echo "Applying Kubernetes Dashboard..."
kubectl apply -f kubernetes-dashboard.yaml
kubectl apply -f kubernetes-dashboard-ingress.yaml
kubectl apply -f kubernetes-dashboard-secret.yaml
kubectl apply -f kubernetes-dashboard-admin-token.yaml

echo "Setup completed successfully!"
