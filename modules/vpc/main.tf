resource "aws_vpc" "web_vpc" {
  cidr_block           = var.vpc_configuration["vpc_cidr_block"]
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name        = "${var.random_pet_id}-vpc"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )
}

resource "aws_subnet" "vpc_subnet" {
  vpc_id                  = aws_vpc.web_vpc.id
  cidr_block              = var.vpc_configuration["subnet_cidr_block"]
  availability_zone       = var.vpc_configuration["availability_zone"]
  map_public_ip_on_launch = var.map_public_ip

  tags = merge(
    {
      Name        = "${var.random_pet_id}-subnet"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_vpc.id

  tags = merge(
    {
      Name        = "${var.random_pet_id}-igw"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.web_vpc.id

  tags = merge(
    {
      Name        = "${var.random_pet_id}-rt"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = var.vpc_configuration["destination_cidr_block"]
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.vpc_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_network_acl" "main" {
  vpc_id     = aws_vpc.web_vpc.id
  subnet_ids = [aws_subnet.vpc_subnet.id]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    {
      Name        = "${var.random_pet_id}-nacl"
      Environment = var.environment
      Terraform   = "true"
    },
    var.additional_tags
  )
}