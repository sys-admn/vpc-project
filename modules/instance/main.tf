resource "aws_instance" "web" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = var.associate_public_ip
  key_name                    = var.key_name
  monitoring                  = var.enable_monitoring

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(
    {
      Name        = "${var.random_pet_id}-${count.index + 1}"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )
  
  lifecycle {
    create_before_destroy = true
  }
  
  depends_on = [aws_key_pair.instance_key]
}

resource "aws_eip" "my_eip" {
  count      = var.instance_count
  instance   = aws_instance.web[count.index].id
  domain     = "vpc"
  depends_on = [var.internet_gateway_dependency]
  
  tags = merge(
    {
      Name        = "${var.random_pet_id}-eip-${count.index + 1}"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )
}

resource "aws_key_pair" "instance_key" {
  key_name   = var.key_name
  public_key = var.public_key_content != "" ? var.public_key_content : file(var.public_key_path)
  
  tags = merge(
    {
      Name        = "${var.random_pet_id}-key"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )
}