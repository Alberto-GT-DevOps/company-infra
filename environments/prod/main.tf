module "prod_network" {
  source      = "../../modules/networking"
  project     = "bto"
  environment = "prod"
}

module "eks" {
  source      = "../../modules/EKS"
  project     = "bto"
  environment = "prod"

  vpc_id             = module.prod_network.vpc_id
  private_subnet_ids = module.prod_network.private_subnet_ids
  public_subnet_ids  = module.prod_network.public_subnet_ids

  enable_irsa = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  access_entries = {
    admin_user = {
      principal_arn = "arn:aws:iam::045306125645:user/terraform"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

}

module "ebs_csi_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "ebs-csi-role"
  attach_ebs_csi_policy = true # Built-in shortcut for EBS

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}