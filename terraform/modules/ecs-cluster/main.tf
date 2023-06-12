resource "aws_ecs_cluster" "ecs_cluster" {
  name = "terraform-cluster-${terraform.workspace}"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_launch_template" "launch_config" {
  image_id = "ami-0c6b5b7ffdb17cb99"
  iam_instance_profile {
    name = var.iam_name
  }
  vpc_security_group_ids = [var.ecs_security_group_id]
  instance_type          = var.instance_type
  key_name               = "ecs-ec2-key-pair"
  user_data              = filebase64("user-data.sh")
  name                   = "launch-template-${terraform.workspace}"
}