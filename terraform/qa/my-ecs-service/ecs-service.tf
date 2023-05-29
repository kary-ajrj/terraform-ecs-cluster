provider "aws" {
  region = "us-west-2"
}

resource "aws_ecs_task_definition" "task_example_qa" {
  family                = "service"
  container_definitions = jsonencode([
    {
      name              = "hello"
      image             = data.aws_ecr_repository.ecr_example.repository_url
      memoryReservation = 985
      essential         = true
      portMappings      = [
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

resource "aws_ecs_service" "service_example_qa" {
  name                  = "ecs-service-qa"
  cluster               = data.terraform_remote_state.ecsCluster.outputs.ecs_cluster_id
  task_definition       = aws_ecs_task_definition.task_example_qa.arn
  launch_type           = "EC2"
  desired_count         = 1
  wait_for_steady_state = true
  load_balancer {
    container_name   = "hello"
    container_port   = 3000
    target_group_arn = data.terraform_remote_state.ecsCluster.outputs.ecs_alb_target_group
  }
  network_configuration {
    subnets         = [data.terraform_remote_state.network.outputs.first_public_subnet_id]
    security_groups = [data.terraform_remote_state.network.outputs.security_group_id]
  }
}