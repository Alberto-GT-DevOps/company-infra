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
}

