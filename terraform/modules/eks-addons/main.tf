# terraform/modules/eks-addons/main.tf

# Wait for the cluster to be ready
resource "time_sleep" "wait_for_cluster" {
  create_duration = "30s"
  
  triggers = {
    cluster_name = var.cluster_name
  }
}

# CoreDNS Add-on
resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name   = "coredns"
  
  addon_version               = var.coredns_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  
  tags = var.common_tags
  
  depends_on = [time_sleep.wait_for_cluster]
}

# kube-proxy Add-on
resource "aws_eks_addon" "kube_proxy" {
  cluster_name = var.cluster_name
  addon_name   = "kube-proxy"
  
  addon_version               = var.kube_proxy_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  
  tags = var.common_tags
  
  depends_on = [time_sleep.wait_for_cluster]
}

# VPC CNI Add-on
resource "aws_eks_addon" "vpc_cni" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"
  
  addon_version               = var.vpc_cni_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  
  tags = var.common_tags
  
  depends_on = [time_sleep.wait_for_cluster]
}

# EBS CSI Driver Add-on with IAM role
resource "aws_eks_addon" "ebs_csi" {
  cluster_name = var.cluster_name
  addon_name   = "aws-ebs-csi-driver"
  
  addon_version               = var.ebs_csi_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "PRESERVE"
  service_account_role_arn    = var.ebs_csi_driver_role_arn
  
  tags = var.common_tags
  
  depends_on = [time_sleep.wait_for_cluster]
}