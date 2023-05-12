resource "aws_vpc" "ecs_vpc_qa" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = {
    Name = "terraform-VPC"
  }
}

resource "aws_subnet" "ecs_public_subnet_one_qa" {
  vpc_id                  = aws_vpc.ecs_vpc_qa.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "ecs_public_subnet_two_qa" {
  vpc_id                  = aws_vpc.ecs_vpc_qa.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "IG_qa" {
  vpc_id = aws_vpc.ecs_vpc_qa.id
}

resource "aws_route_table" "routeTable_qa" {
  vpc_id = aws_vpc.ecs_vpc_qa.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG_qa.id
  }
}

resource "aws_route_table_association" "firstRouteTableAssociation_qa" {
  route_table_id = aws_route_table.routeTable_qa.id
  subnet_id      = aws_subnet.ecs_public_subnet_one_qa.id
}

resource "aws_route_table_association" "secondRouteTableAssociation_qa" {
  route_table_id = aws_route_table.routeTable_qa.id
  subnet_id      = aws_subnet.ecs_public_subnet_two_qa.id
}

resource "aws_security_group" "ecs_security_group_qa" {
  vpc_id = aws_vpc.ecs_vpc_qa.id
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