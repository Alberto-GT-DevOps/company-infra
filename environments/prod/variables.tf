variable "aws_region" {
  description = "AWS region"
  type        = string
  default = "us-west-2"
}

variable "project" {
  type    = string
  default = "bto"
}

variable "environment" {
  type    = string
  default = "prod"
}