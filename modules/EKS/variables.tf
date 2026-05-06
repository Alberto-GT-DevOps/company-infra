variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "cluster_version" {
  type    = string
  default = "1.32"
}

variable "cluster_addons" {
  type    = any
  default = {}
}

variable "access_entries" {
  type    = any
  default = {}
}

variable "enable_irsa" {
  type    = bool
  default = true
}