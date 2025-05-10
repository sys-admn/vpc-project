output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.web_vpc.id
}

output "subnet_id" {
  description = "The ID of the created subnet"
  value       = aws_subnet.vpc_subnet.id
}

output "vpc_configuration" {
  description = "The VPC configuration settings"
  value       = var.vpc_configuration
}

output "internet_gateway_id" {
  description = "The ID of the created Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "route_table_id" {
  description = "The ID of the created route table"
  value       = aws_route_table.my_route_table.id
}

output "network_acl_id" {
  description = "The ID of the created Network ACL"
  value       = aws_network_acl.main.id
}