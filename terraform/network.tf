resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = {
    Name = "terraform-VPC"
  }
}

resource "aws_subnet" "ecs_public_subnet" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "ecs_public_subnet_two" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "IG" {
  vpc_id = aws_vpc.ecs_vpc.id
}

resource "aws_route_table" "routeTable" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG.id
  }
}

resource "aws_route_table_association" "routeTableAssociation" {
  route_table_id = aws_route_table.routeTable.id
  subnet_id      = aws_subnet.ecs_public_subnet.id
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
}