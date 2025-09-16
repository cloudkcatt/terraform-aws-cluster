#!/bin/bash

# Clean up Kubernetes resources before destroying the cluster
# This prevents orphaned AWS resources

CLUSTER_NAME=${1:-eks-cluster}
REGION=${2:-us-west-2}

echo "Cleaning up Kubernetes resources for cluster: $CLUSTER_NAME"

# Update kubeconfig
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION 2>/dev/null || exit 0

# Delete all LoadBalancer services
echo "Deleting LoadBalancer services..."
kubectl get svc --all-namespaces -o json | \
  jq -r '.items[] | select(.spec.type=="LoadBalancer") | "\(.metadata.namespace)/\(.metadata.name)"' | \
  while read svc; do
    ns=$(echo $svc | cut -d'/' -f1)
    name=$(echo $svc | cut -d'/' -f2)
    echo "Deleting service: $ns/$name"
    kubectl delete svc -n $ns $name --timeout=60s || true
  done

# Delete all Ingress resources
echo "Deleting Ingress resources..."
kubectl get ingress --all-namespaces -o json 2>/dev/null | \
  jq -r '.items[] | "\(.metadata.namespace)/\(.metadata.name)"' | \
  while read ing; do
    ns=$(echo $ing | cut -d'/' -f1)
    name=$(echo $ing | cut -d'/' -f2)
    echo "Deleting ingress: $ns/$name"
    kubectl delete ingress -n $ns $name --timeout=60s || true
  done

# Wait for AWS resources to be cleaned up
echo "Waiting for AWS resources to be cleaned up..."
sleep 30

echo "Cleanup complete!"