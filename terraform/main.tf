provider "aws" {
  region = "us-west-2"
}

resource "aws_ecr_repository" "ecr_example" {
  name = "my_terraform_ecr_example"
}

resource "aws_ecs_task_definition" "task_example" {
  family                = "service"
  container_definitions = jsonencode([
    {
      name         = "hello"
      image        = aws_ecr_repository.ecr_example.repository_url
      memory       = 985
      cpu          = 512
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
  memory                   = 985
  cpu                      = 512

}

resource "aws_ecs_service" "service_example" {
  name            = "ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_example.arn
  launch_type     = "EC2"
  desired_count   = 1
  network_configuration {
    subnets         = [aws_subnet.ecs_public_subnet.id]
    security_groups = [aws_security_group.ecs_security_group.id]
  }
}