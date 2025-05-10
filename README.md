# Terraform AWS VPC and EC2 Infrastructure

This project creates a complete AWS infrastructure using Terraform, including VPC, subnets, security groups, and EC2 instances.

## Architecture

The project is organized into reusable modules:

- **VPC Module**: Creates a VPC with public subnet, internet gateway, route table, and network ACL
- **Security Group Module**: Creates security groups with configurable ingress rules
- **Instance Module**: Creates EC2 instances with elastic IPs and SSH key pairs

## Prerequisites

- Terraform v1.8+
- AWS CLI configured with appropriate credentials
- SSH key pair for EC2 instance access

## Usage

1. Clone the repository
2. Update the variables in `terraform.tfvars` (create this file) or use environment variables
3. Initialize Terraform:

```bash
terraform init
```

4. Plan the deployment:

```bash
terraform plan
```

5. Apply the configuration:

```bash
terraform apply
```

## Configuration

### Required Variables

- `aws_region`: AWS region to deploy resources (default: "us-west-2")
- `key_name`: Name of the SSH key pair
- `public_key_path` or `public_key_content`: Path to public key file or the content of the public key

### Optional Variables

- `instance_count`: Number of EC2 instances (default: 2)
- `instance_type`: Type of EC2 instance (default: "t2.micro")
- `environment`: Environment name (default: "dev")
- `vpc_configuration`: Map of VPC configuration settings
- `security_group_ingress_rules`: List of security group ingress rules

## Security Best Practices

- Limit SSH access to specific IP addresses by updating the `security_group_ingress_rules` variable
- Use encrypted EBS volumes for EC2 instances
- Apply proper tagging for resource management
- Use environment-specific configurations

## Outputs

- `domain_names`: Public DNS names of the EC2 instances
- `public_ips`: Public IP addresses of the EC2 instances
- `elastic_ips`: Elastic IP addresses assigned to the instances
- `vpc_id`: The ID of the created VPC
- `subnet_id`: The ID of the created subnet
- `security_group_id`: The ID of the created security group
- `instance_ids`: IDs of the created EC2 instances

## Cleanup

To destroy all resources created by this project:

```bash
terraform destroy
```
