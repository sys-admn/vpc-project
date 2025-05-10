output "domain_names" {
  description = "Public DNS names of the EC2 instances"
  value       = aws_instance.web[*].public_dns
}

output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.web[*].public_ip
}

output "elastic_ips" {
  description = "Elastic IP addresses assigned to the instances"
  value       = aws_eip.my_eip[*].public_ip
}

output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = aws_instance.web[*].id
}

output "instance_arns" {
  description = "ARNs of the created EC2 instances"
  value       = aws_instance.web[*].arn
}

output "key_name" {
  description = "Name of the SSH key pair used for the instances"
  value       = aws_key_pair.instance_key.key_name
}