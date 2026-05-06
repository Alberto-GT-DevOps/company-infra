module "prod_network" {
  source      = "../../modules/networking"
  project     = "bto"
  environment = "prod"
}

module "eks" {
  source      = "../../modules/EKS"
  project     = "bto"
  environment = "prod"

  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  public_subnet_ids  = module.networking.public_subnet_ids
}