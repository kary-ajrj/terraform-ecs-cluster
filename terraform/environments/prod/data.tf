data "terraform_remote_state" "infra" {
  backend = "s3"
  config  = {
    bucket = "my-infrastructure-state"
    key    = "env:/prod/prod-base-infra-terraform-state"
    region = "us-west-2"
  }
}