variable "vpc_configuration" {
  description = "VPC configuration settings"
  type        = map(string)
  validation {
    condition     = can(cidrnetmask(var.vpc_configuration["vpc_cidr_block"]))
    error_message = "The vpc_cidr_block must be a valid CIDR block."
  }
}

variable "random_pet_id" {
  description = "Random pet ID for unique naming"
  type        = string
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

variable "map_public_ip" {
  description = "Whether to map public IP on launch for instances in the subnet"
  type        = bool
  default     = true
}