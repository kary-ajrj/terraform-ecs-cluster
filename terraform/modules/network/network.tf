resource "aws_vpc" "ecs_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = {
    Name = "vpc-${terraform.workspace}"
  }
}

resource "aws_subnet" "ecs_public_subnet_one" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = var.subnet_one_cidr
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags                 = {
    Name = "subnet-one-${terraform.workspace}"
  }
}

resource "aws_subnet" "ecs_public_subnet_two" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = var.subnet_two_cidr
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags                 = {
    Name = "subnet-two-${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags                 = {
    Name = "internet-gateway-${terraform.workspace}"
  }
}

resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
  tags                 = {
    Name = "route-table-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "firstRouteTableAssociation" {
  route_table_id = aws_route_table.routeTable.id
  subnet_id      = aws_subnet.ecs_public_subnet_one.id
}

resource "aws_route_table_association" "secondRouteTableAssociation" {
  route_table_id = aws_route_table.routeTable.id
  subnet_id      = aws_subnet.ecs_public_subnet_two.id
}

resource "aws_security_group" "ecs_security_group" {
  vpc_id = aws_vpc.ecs_vpc.id
  ingress {
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags                 = {
    Name = "security-group-${terraform.workspace}"
  }
}