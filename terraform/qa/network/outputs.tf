output "vpc_id" {
  value = aws_vpc.ecs_vpc_qa.id
}

output "first_public_subnet_id" {
  value = aws_subnet.ecs_public_subnet_one_qa.id
}

output "second_public_subnet_id" {
  value = aws_subnet.ecs_public_subnet_two_qa.id
}

output "security_group_id" {
  value = aws_security_group.ecs_security_group_qa.id
}

output "iam_name" {
  value = aws_iam_instance_profile.ecs_agent_profile.name
}