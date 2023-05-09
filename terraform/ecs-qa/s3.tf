 terraform {
   backend "s3" {
     bucket = "my-infrastructure-state"
     key    = "qa-ecs-terraform-state"
     region = "us-west-2"
   }
 }