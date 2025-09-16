# terraform/environments/sandbox/main.tf

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Networking Module
module "networking" {
  source = "../../modules/networking"

  cluster_name = var.cluster_name
  vpc_cidr     = var.vpc_cidr
  common_tags  = local.common_tags
}

# EKS Cluster Module
module "eks_cluster" {
  source = "../../modules/eks-cluster"

  cluster_name                         = var.cluster_name
  kubernetes_version                   = var.kubernetes_version
  subnet_ids                          = concat(module.networking.public_subnet_ids, module.networking.private_subnet_ids)
  private_subnet_ids                  = module.networking.private_subnet_ids
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  
  desired_nodes  = var.desired_nodes
  min_nodes      = var.min_nodes
  max_nodes      = var.max_nodes
  instance_types = var.instance_types
  
  common_tags = local.common_tags
}