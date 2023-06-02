terraform {
  backend "s3" {
    bucket = "my-infrastructure-state"
    key    = "qa-base-infra-terraform-state"
    region = "us-west-2"
  }
}