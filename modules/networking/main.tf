resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.vpc_name
    }
}

data "aws_availability_zones" "available" {
    state = "available"
    filter {
        name = "opt-in-status"
        values = ["opt-in-not-required"]
    }
}

locals {
    azs = slice(data.aws_availability_zones.available.names, 0, min(3, length(data.aws_availability_zones.available)))
}

resource "aws_subnet" "public_subnets" {
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = element(var.public_subnet_cidrs, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]

    tags = {
        Name = "Public Subnet ${count.index + 1}"
    }
}

resource "aws_subnet" "private_subnets" {
    count = length(var.private_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    cidr_block = element(var.private_subnet_cidrs, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = {
        Name = "Private subnet ${count.index + 1}"
    }    
}
