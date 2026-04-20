terraform {
  backend "s3" {
    bucket       = "bto-tf-state-unique-id"
    key          = "prod/terraform.tfstate"
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true
  }
}