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