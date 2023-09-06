provider "aws" {
  region  = "eu-central-1"
}
# VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr
}
#SUBNET
resource "aws_subnet" "public_subnet" {
  vpc_id   = aws_vpc.main.id
  cidr_block  = var.publicCIDR
  availability_zone  = var.availability_zone
}
#Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}
#Route Table
resource "aws_route_table" "main_rout_table" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "main"
  }
}
# Route Table Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main_rout_table.id
}
#Security Group
resource "aws_security_group" "allow_tls" {
  name_prefix   = "allow_traffic"
  description   = "Allow TLS inbound traffic"
  vpc_id        = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.cidr]
    }
  }
}

# EC2 Instance
resource "aws_instance" "ec2" {
  ami           = var.instance_AMI
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet.id
  associate_public_ip_address = true

}

