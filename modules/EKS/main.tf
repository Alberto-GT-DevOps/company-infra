locals {
  name_prefix = "${var.project}-${var.environment}"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${local.name_prefix}-eks"
  cluster_version = var.cluster_version

  access_entries = var.access_entries
  enable_irsa    = var.enable_irsa

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # API endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Authentication (Modern API mode)
  enable_cluster_creator_admin_permissions = true

  # Managed node group (simple baseline)
  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
    }
  }

  tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  }

}