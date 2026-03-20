terraform {
  backend "s3" {
    bucket       = "bto-tf-state-unique-id"
    key          = "prod/terraform.tfstate" # Path within the bucket
    region       = "us-west-2"
    use_lockfile = true
    encrypt      = true
  }
}