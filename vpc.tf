resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = var.standard_tags
}

resource "aws_subnet" "main" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  tags = var.standard_tags

}

resource "aws_security_group" "allow_inbound_apache" {
  name = "allow_inbound_apache"
  description = "Allow inbound traffic"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "TLS from VPC"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = var.standard_tags
}
