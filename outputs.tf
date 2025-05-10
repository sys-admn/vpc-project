output "domain_names" {
  description = "Public DNS names of the EC2 instances"
  value       = module.instance.domain_names
}

output "public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = module.instance.public_ips
}

output "elastic_ips" {
  description = "Elastic IP addresses assigned to the instances"
  value       = module.instance.elastic_ips
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the created subnet"
  value       = module.vpc.subnet_id
}

output "security_group_id" {
  description = "The ID of the created security group"
  value       = module.security_group.security_group_id
}

output "instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = module.instance.instance_ids
}

output "random_pet_id" {
  description = "The random pet ID used for naming resources"
  value       = random_pet.name.id
}