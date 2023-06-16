resource "aws_subnet" "ecs_private_subnet_one" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.pvt_subnet_one_cidr
  availability_zone = "us-west-2a"
  tags              = {
    Name = "private-subnet-one-${terraform.workspace}"
  }
}

resource "aws_subnet" "ecs_private_subnet_two" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = var.pvt_subnet_two_cidr
  availability_zone = "us-west-2b"
  tags              = {
    Name = "private-subnet-two-${terraform.workspace}"
  }
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.IG]
  domain     = "vpc"
}

resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.ecs_public_subnet_one.id
  allocation_id = aws_eip.eip.id
}

resource "aws_route_table" "NatRouteTable" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "nat-route-table-${terraform.workspace}"
  }
}

resource "aws_route_table_association" "pvtFirstRouteTableAssociation" {
  route_table_id = aws_route_table.NatRouteTable.id
  subnet_id      = aws_subnet.ecs_private_subnet_one.id
}

resource "aws_route_table_association" "pvtSecondRouteTableAssociation" {
  route_table_id = aws_route_table.NatRouteTable.id
  subnet_id      = aws_subnet.ecs_private_subnet_two.id
}