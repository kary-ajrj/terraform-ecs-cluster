resource "aws_ecs_cluster" "ecs_cluster" {
  name = "terraform-cluster-${terraform.workspace}"
}

resource "aws_lb" "ecs_alb" {
  name            = "ecs-alb-${terraform.workspace}"
  security_groups = [var.alb_security_group_id]
  subnets         = [
    var.first_public_subnet_id,
    var.second_public_subnet_id
  ]
}

resource "aws_lb_target_group" "ecs_alb_target_group" {
  name        = "ecs-alb-target-group-${terraform.workspace}"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 3000
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
    type             = "forward"
  }
  tags = {
    Name = "lb-listener-${terraform.workspace}"
  }
}