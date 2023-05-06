module "networking" {
  source = "../network"
}

module "ecr" {
  source = "../ecr"
}

module "s3" {
  source = "../s3"
}