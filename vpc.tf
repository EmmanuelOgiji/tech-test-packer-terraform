# VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.standard_tags
}

# Data source to get availability zones
data "aws_availability_zones" "all" {}

# Multiple subnets for multi-az
resource "aws_subnet" "main" {
  count             = length(var.subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.all.names[count.index]
  tags              = var.standard_tags
}

# Security Group to be used by both instances in asg and the elb
resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  # HTTP access from anywhere
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  # HTTPS access from anywhere (to allow SSM)
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = var.standard_tags
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Endpoint services for SSM connection
data "aws_vpc_endpoint_service" "ssm" {
  service      = "ssm"
  service_type = "Interface"
}

data "aws_vpc_endpoint_service" "ssmmessages" {
  service      = "ssmmessages"
  service_type = "Interface"
}

data "aws_vpc_endpoint_service" "ec2messages" {
  service      = "ec2messages"
  service_type = "Interface"
}

# Use local var to build list of endpoint services
locals {
  endpoint_services = [
    data.aws_vpc_endpoint_service.ssm.service_name,
    data.aws_vpc_endpoint_service.ssmmessages.service_name,
    data.aws_vpc_endpoint_service.ec2messages.service_name
  ]
}


# Interface VPC endpoints for SSM Connection
resource "aws_vpc_endpoint" "ssm" {
  count             = length(local.endpoint_services)
  vpc_id            = aws_vpc.main.id
  service_name      = local.endpoint_services[count.index]
  vpc_endpoint_type = "Interface"
  subnet_ids        = aws_subnet.main.*.id
  security_group_ids = [
    aws_security_group.instance_sg.id,
  ]

  private_dns_enabled = true
}