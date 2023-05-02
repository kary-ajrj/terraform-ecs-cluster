output "vpc_id" {
  value = aws_vpc.ecs_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.ecs_public_subnet.id
}

output "security_group_id" {
  value = aws_security_group.ecs_security_group.id
}

output "second_public_subnet_id" {
  value = aws_subnet.ecs_public_subnet_two.id
}

output "iam_name" {
  value = aws_iam_instance_profile.ecs_agent.name
}