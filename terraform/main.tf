provider "aws" {
  region = "us-west-2"
}

resource "aws_ecr_repository" "ecr_example" {
  name = "my_terraform_ecr_example"
}

resource "aws_ecs_task_definition" "task_example" {
  family                = "service"
  execution_role_arn    = "arn:aws:iam::675220158921:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
      name         = "hello"
      image        = aws_ecr_repository.ecr_example.repository_url
      #      cpu = 512
      memory       = 1000
      memoryReservation : 750
      essential    = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  #  requires_compatibilities = ["EC2"]
  #  network_mode = "awsvpc"
  #  memory = "1024"
  #  cpu = "512"
}

resource "aws_ecs_service" "service_example" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_example.arn
  #  launch_type = "EC2"
  desired_count   = 1
  #  network_configuration {
  #    subnets = [aws_subnet.ecs_subnet.id]
  #    security_groups = [aws_security_group.ecs_security_group.id]
  #  }
}