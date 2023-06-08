output "vpc_id" {
  value = aws_vpc.ecs_vpc.id
}

output "first_public_subnet_id" {
  value = aws_subnet.ecs_public_subnet_one.id
}

output "second_public_subnet_id" {
  value = aws_subnet.ecs_public_subnet_two.id
}

output "first_pvt_subnet_id" {
  value = aws_subnet.ecs_private_subnet_one.id
}

output "second_pvt_subnet_id" {
  value = aws_subnet.ecs_private_subnet_two.id
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_security_group.id
}

output "alb_security_group_id" {
  value = aws_security_group.alb_security_group.id
}

output "iam_name" {
  value = aws_iam_instance_profile.ecs_agent_profile.name
}