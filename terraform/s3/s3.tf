 terraform {
   backend "s3" {
     bucket = var.bucket
     key    = var.key
     region = "us-west-2"
   }
 }

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket
}