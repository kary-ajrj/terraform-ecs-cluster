 terraform {
   backend "s3" {
     bucket = "my-infrastructure-state"
     key    = "ecs-terraform-state"
     region = "us-west-2"
   }
 }