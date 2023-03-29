resource "aws_lb" "ecs_alb" {
  name                       = "ecs-alb"
#  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_sec_group.id]
  subnets                    = [aws_subnet.ecs_public_subnet.id, aws_subnet.ecs_subnet_b.id]
#  enable_deletion_protection = false
}

resource "aws_lb_target_group" "ecs_alb_target_group" {
  name        = "ecs-alb-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 3000
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs_alb_target_group.arn
    type             = "forward"
  }
}