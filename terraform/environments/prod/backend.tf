terraform {
  backend "s3" {
    bucket = "my-infrastructure-state"
    key    = "prod-service-terraform-state"
    region = "us-west-2"
  }
}