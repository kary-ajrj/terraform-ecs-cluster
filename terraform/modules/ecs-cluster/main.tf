resource "aws_ecs_cluster" "ecs_cluster" {
  name = "terraform-cluster-${terraform.workspace}"
  /*setting {
    name  = "containerInsights"
    value = "enabled"
  }*/
}

resource "aws_launch_template" "launch_config" {
  image_id = "ami-036f51d99e53d0c67"
  iam_instance_profile {
    name = var.iam_name
  }
  vpc_security_group_ids = [var.ecs_security_group_id]
  instance_type          = var.instance_type
  user_data              = filebase64("user-data.sh")
  name                   = "launch-template-${terraform.workspace}"
}