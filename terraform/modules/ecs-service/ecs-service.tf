resource "aws_ecs_task_definition" "task_example" {
  family                = "service"
  cpu                   = 512
  memory                = 512
  container_definitions = jsonencode([
    {
      name         = "hello"
      cpu          = 512
      memory       = 512
      image        = data.aws_ecr_repository.ecr_example.repository_url
      essential    = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
    }
  ])
  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
}

resource "aws_ecs_service" "service_example" {
  name                  = "ecs-service-${terraform.workspace}"
  cluster               = var.ecs_cluster_id
  task_definition       = aws_ecs_task_definition.task_example.arn
  launch_type           = "EC2"
  desired_count         = 1
  wait_for_steady_state = true
  load_balancer {
    container_name   = "hello"
    container_port   = 3000
    target_group_arn = var.ecs_alb_tg_arn
  }
  network_configuration {
    subnets         = [var.first_pvt_subnet_id, var.second_pvt_subnet_id]
    security_groups = [var.ecs_security_group_id]
  }
}