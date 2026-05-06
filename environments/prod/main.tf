module "prod_network" {
  source      = "../../modules/networking"
  project     = var.project
  environment = var.environment
}

module "eks" {
  source      = "../../modules/EKS"
  project     = var.project
  environment = var.environment

  enable_irsa = true

  vpc_id             = module.prod_network.vpc_id
  private_subnet_ids = module.prod_network.private_subnet_ids
  public_subnet_ids  = module.prod_network.public_subnet_ids

  access_entries = {
    admin_user = {
      principal_arn = "arn:aws:iam::045306125645:user/terraform"
      policy_associations = {
        admin = {
          policy_arn   = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.30-0-eksbuild.1"
  service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn

  depends_on = [module.eks]
}

module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name_prefix      = "${var.project}-${var.environment}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}