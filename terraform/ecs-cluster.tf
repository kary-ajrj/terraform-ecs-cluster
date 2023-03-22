resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = {
    Name = "terraform-VPC"
  }
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

resource "aws_subnet" "ecs_public_subnet" {
  vpc_id                  = aws_vpc.ecs_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "ecs_security_group" {
  vpc_id = aws_vpc.ecs_vpc.id
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

resource "aws_launch_configuration" "launch_config" {
  image_id                    = "ami-0c6b5b7ffdb17cb99"
  iam_instance_profile        = aws_iam_instance_profile.ecs_agent.name
  security_groups             = [aws_security_group.ecs_security_group.id]
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  key_name                    = "ecs-ec2-key-pair"
  user_data                   = <<EOF
#!/bin/bash
echo "ECS_CLUSTER=terraform-cluster" >> /etc/ecs/ecs.config
EOF
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "terraform-cluster"
}

resource "aws_autoscaling_group" "auto_scale" {
  max_size             = 1
  min_size             = 1
  launch_configuration = aws_launch_configuration.launch_config.name
  vpc_zone_identifier  = [aws_subnet.ecs_public_subnet.id]
  health_check_type    = "EC2"
  desired_capacity     = 1
  termination_policies = [
    "OldestInstance"
  ]
  default_cooldown          = 30
  health_check_grace_period = 30
  lifecycle {
    create_before_destroy = true
  }
}

#resource "aws_ecs_capacity_provider" "capacity_provider" {
#  name = "capacity_provider_example"
#  auto_scaling_group_provider {
#    auto_scaling_group_arn = aws_autoscaling_group.auto_scale.arn
#  }
#}
#
#resource "aws_ecs_cluster_capacity_providers" "capacity_provider" {
#  cluster_name = aws_ecs_cluster.ecs_cluster.name
#  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
#  default_capacity_provider_strategy {
#    base = 1
#    weight = 100
#    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
#  }
#}