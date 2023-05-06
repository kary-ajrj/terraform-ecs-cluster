resource "aws_lb" "ecs_alb_qa" {
  name               = "ecs-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group_qa.id]
  subnets            = [module.networking.public_subnet_id, module.networking.second_public_subnet_id]
}

resource "aws_lb_target_group" "ecs_alb_target_group_qa" {
  name        = "ecs-alb-target-group"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = module.networking.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "alb_listener_qa" {
  load_balancer_arn = aws_lb.ecs_alb_qa.arn
  port              = 3000
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.ecs_alb_target_group_qa.arn
    type             = "forward"
  }
}

resource "aws_security_group" "alb_security_group_qa" {
  vpc_id = module.networking.vpc_id
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