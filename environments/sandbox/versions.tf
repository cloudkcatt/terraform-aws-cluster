# terraform/environments/sandbox/versions.tf

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }

  # Backend configuration - update with your actual bucket name
  backend "s3" {
    # These values will be provided via backend-config during init
    # bucket         = "terraform-state-terraform-XXXXX"
    # key            = "eks/sandbox/terraform.tfstate"
    # region         = "us-west-2"
    # dynamodb_table = "terraform-state-lock"
    # encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}