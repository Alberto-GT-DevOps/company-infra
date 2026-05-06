output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "oidc_provider_arn" {
    value = module.eks.oidc_provider_arn
}