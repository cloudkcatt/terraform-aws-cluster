.PHONY: help init plan apply destroy clean

TERRAFORM_DIR = terraform/environments/sandbox
CLUSTER_NAME = eks-cluster
AWS_REGION = us-west-2

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Initialize Terraform
	cd $(TERRAFORM_DIR) && terraform init

plan: ## Plan Terraform changes
	cd $(TERRAFORM_DIR) && terraform plan

apply: ## Apply Terraform changes
	cd $(TERRAFORM_DIR) && terraform apply

destroy: clean ## Destroy all resources
	cd $(TERRAFORM_DIR) && terraform destroy

clean: ## Clean up Kubernetes resources before destroy
	./scripts/cleanup-k8s-resources.sh $(CLUSTER_NAME) $(AWS_REGION)

kubeconfig: ## Update kubeconfig
	aws eks update-kubeconfig --region $(AWS_REGION) --name $(CLUSTER_NAME)

fmt: ## Format Terraform files
	terraform fmt -recursive terraform/

validate: ## Validate Terraform configuration
	cd $(TERRAFORM_DIR) && terraform validate