module "prod_network" {
  source   = "../../modules/networking"
  vpc_name = "BTO-VPC"
}