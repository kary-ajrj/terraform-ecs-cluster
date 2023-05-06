variable "key" {
  description = "Location of the state file in the bucket."
  type = string
  default = "ecs-terraform-state"
}

variable "bucket" {
  description = "Name of the bucket."
  type = string
  default = "infrastructure-state"
}