 terraform {
   backend "s3" {
     bucket = "my-infrastructure-state"
     key    = "prod-ecs-terraform-state"
     region = "us-west-2"
   }
 }