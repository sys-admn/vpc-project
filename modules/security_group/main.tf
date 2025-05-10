resource "aws_security_group" "web_sg" {
  name        = "${var.sg_name_prefix}-${var.random_pet_id}"
  description = "Security group for web instances"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    {
      Name        = "${var.sg_name_prefix}-${var.random_pet_id}"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )

  lifecycle {
    create_before_destroy = true
  }
}