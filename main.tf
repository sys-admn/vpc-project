terraform {
  required_version = ">= 1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.91.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0"
    }
  }
}

locals {
  sg_name_prefix = "web-sg"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Terraform   = "true"
    Owner       = var.owner
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = local.common_tags
  }
}

provider "random" {}

resource "random_pet" "name" {
  length    = 2
  separator = "-"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_configuration = {
    vpc_cidr_block         = var.vpc_configuration["vpc_cidr_block"]
    subnet_cidr_block      = var.vpc_configuration["subnet_cidr_block"]
    availability_zone      = var.vpc_configuration["availability_zone"]
    destination_cidr_block = var.vpc_configuration["destination_cidr_block"]
  }
  random_pet_id  = random_pet.name.id
  environment    = var.environment
  additional_tags = local.common_tags
  map_public_ip  = var.map_public_ip_on_launch
}

module "security_group" {
  source         = "./modules/security_group"
  vpc_id         = module.vpc.vpc_id
  sg_name_prefix = local.sg_name_prefix
  random_pet_id  = random_pet.name.id
  environment    = var.environment
  additional_tags = local.common_tags
  ingress_rules  = var.security_group_ingress_rules
}

module "instance" {
  source            = "./modules/instance"
  instance_count    = var.instance_count
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = var.key_name
  ami_id            = data.aws_ami.linux.id
  random_pet_id     = random_pet.name.id
  environment       = var.environment
  additional_tags   = local.common_tags
  
  # Enhanced instance configuration
  associate_public_ip = var.map_public_ip_on_launch
  enable_monitoring   = var.enable_detailed_monitoring
  root_volume_size    = var.root_volume_size
  root_volume_type    = var.root_volume_type
  public_key_path     = var.public_key_path
  public_key_content  = var.public_key_content
  
  # Dependency for EIP
  internet_gateway_dependency = module.vpc.internet_gateway_id
}

data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}