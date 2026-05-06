variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  type    = string
  default = "bto"
}

variable "environment" {
  type    = string
  default = "prod"
}