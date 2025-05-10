variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "sg_name_prefix" {
  description = "Prefix for the security group name"
  type        = string
}

variable "random_pet_id" {
  description = "Random pet ID for unique naming"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH access"
    },
    {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow ICMP"
    }
  ]
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