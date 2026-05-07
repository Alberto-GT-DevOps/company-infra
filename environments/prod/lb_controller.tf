# Fetch the policy directly from GitHub
data "http" "iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
}

# Create the IAM Policy resource using the fetched JSON
resource "aws_iam_policy" "load_balancer_controller" {
  name        = "${var.project}-${var.environment}-lb-controller-policy"
  description = "Permissions for EKS Load Balancer Controller"
  policy      = data.http.iam_policy.response_body
}

module "lbc_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "${var.project}-${var.environment}-lbc-role"

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }

  role_policy_arns = {
    load_balancer_controller = aws_iam_policy.load_balancer_controller.arn
  }
}