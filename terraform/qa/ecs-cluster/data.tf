data "terraform_remote_state" "network" {
  backend = "s3"
  config  = {
    bucket = "my-infrastructure-state"
    key    = "qa-network-terraform-state"
    region = "us-west-2"
  }
}