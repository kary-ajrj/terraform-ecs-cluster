terraform {
  backend "s3" {
    bucket = "my-infrastructure-state"
    key    = "qa-service-terraform-state"
    region = "us-west-2"
  }
}