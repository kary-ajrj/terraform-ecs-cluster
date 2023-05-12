 terraform {
   backend "s3" {
     bucket = "my-infrastructure-state"
     key    = "qa-network-terraform-state"
     region = "us-west-2"
   }
 }