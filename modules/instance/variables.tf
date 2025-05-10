variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  validation {
    condition     = var.instance_count > 0
    error_message = "Instance count must be greater than 0."
  }
}

variable "instance_type" {
  description = "Type of instance to create"
  type        = string
  validation {
    condition     = contains(["t2.micro", "t2.small", "t3.micro", "t3.small"], var.instance_type)
    error_message = "Instance type must be one of: t2.micro, t2.small, t3.micro, t3.small."
  }
}

variable "subnet_id" {
  description = "The ID of the subnet"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to use"
  type        = string
}

variable "random_pet_id" {
  description = "Random pet ID for unique naming"
  type        = string
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring for the instance"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 8
  validation {
    condition     = var.root_volume_size >= 8
    error_message = "Root volume size must be at least 8 GB."
  }
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2"], var.root_volume_type)
    error_message = "Root volume type must be one of: gp2, gp3, io1, io2."
  }
}

variable "environment" {
  description = "Environment tag for the resources"
  type        = string
  default     = "dev"
}

variable "additional_tags" {
  description = "Additional tags for the resources"
  type        = map(string)
  default     = {}
}

variable "public_key_path" {
  description = "Path to the public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "public_key_content" {
  description = "Content of the public key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "internet_gateway_dependency" {
  description = "Internet gateway dependency for EIP"
  type        = any
  default     = null
}