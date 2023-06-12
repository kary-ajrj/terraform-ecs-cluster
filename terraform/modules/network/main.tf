resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = {
    Name = "vpc-${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags   = {
    Name = "internet-gateway-${terraform.workspace}"
  }
}