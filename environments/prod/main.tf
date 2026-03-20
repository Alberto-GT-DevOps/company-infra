module "prod_network" {
  source      = "../../modules/networking"
  project     = "bto"
  environment = "prod"
}