module "networking" {
  source      = "../../modules/networking"
  project     = var.project
  environment = var.environment
}

module "eks" {
  source      = "../../modules/eks"
  project     = var.project
  environment = var.environment

  enable_irsa = true

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids  = module.networking.public_subnet_ids

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

module "ebs_csi" {
  source            = "../../modules/addons/ebs-csi"
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn

  project     = var.project
  environment = var.environment
  depends_on  = [module.eks]
}

module "aws_load_balancer_controller" {
  source = "../../modules/addons/aws-load-balancer-controller"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn

  project     = var.project
  environment = var.environment
  depends_on  = [module.eks]
}

module "external_secrets_operator" {
  source = "../../modules/addons/external-secrets-operator"

  oidc_provider_arn = module.eks.oidc_provider_arn

  project     = var.project
  environment = var.environment
  depends_on  = [module.eks]
}

module "metrics_server" {
  source = "../../modules/addons/metrics-server"

  depends_on = [module.eks]
}

module "argocd" {
  source = "../../modules/addons/argocd"

  project     = var.project
  environment = var.environment

  depends_on = [module.eks]
}