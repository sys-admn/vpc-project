output "security_group_id" {
  description = "The ID of the created security group"
  value       = aws_security_group.web_sg.id
}

output "security_group_name" {
  description = "The name of the created security group"
  value       = aws_security_group.web_sg.name
}

output "security_group_arn" {
  description = "The ARN of the created security group"
  value       = aws_security_group.web_sg.arn
}