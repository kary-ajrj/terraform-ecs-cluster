provider "aws" {
  region = "us-west-2"
}

resource "aws_ecr_repository" "ecr_example" {
  name = "my_terraform_ecr_example"
}