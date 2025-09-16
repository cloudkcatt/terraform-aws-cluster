# EKS Terraform Setup

Minimal, clean EKS cluster setup with Terraform and GitHub Actions.

## Features

- ✅ 2-node EKS cluster (t3.medium)
- ✅ Public and private subnets with NAT gateways
- ✅ AWS Load Balancer Controller for Ingress
- ✅ Clean destroy with no orphaned resources
- ✅ GitHub Actions automation

## Prerequisites

1. AWS account with bootstrap resources created
2. GitHub secrets configured:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `TF_STATE_BUCKET`
   - `TF_STATE_LOCK_TABLE`
   - `CLUSTER_NAME`

## Quick Start

### Local Deployment
```bash
# Initialize
cd terraform/environments/sandbox
terraform init \
  -backend-config="bucket=YOUR_BUCKET" \
  -backend-config="key=eks/sandbox/terraform.tfstate" \
  -backend-config="region=us-west-2" \
  -backend-config="dynamodb_table=terraform-state-lock"

# Deploy
terraform apply

# Configure kubectl
aws eks update-kubeconfig --region us-west-2 --name eks-cluster

# Install AWS Load Balancer Controller
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"
helm repo add eks https://aws.github.io/eks-charts
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-cluster