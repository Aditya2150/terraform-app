output "vpc_id" {
  description = "ID of the main VPC"
  value       = aws_vpc.main.id
}

output "alb_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.ecs_sg.id
}

output "public_subnet_id_list" {
  description = "Public Subnets List"
  value       = values(aws_subnet.public)[*].id
}

output "private_subnet_id_list" {
  description = "Private Subnets List"
  value       = values(aws_subnet.private)[*].id
}
