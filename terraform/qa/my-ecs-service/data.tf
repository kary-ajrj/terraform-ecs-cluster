data "aws_ecr_repository" "ecr_example" {
  name = "my_terraform_ecr_example"
}

data "terraform_remote_state" "network" {
  backend = "s3"
  config  = {
    bucket = "my-infrastructure-state"
    key    = "qa-network-terraform-state"
    region = "us-west-2"
  }
}

data "terraform_remote_state" "ecsCluster" {
  backend = "s3"
  config  = {
    bucket = "my-infrastructure-state"
    key    = "qa-ecs-cluster-terraform-state"
    region = "us-west-2"
  }
}