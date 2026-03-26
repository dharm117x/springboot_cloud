# 1. Look up the existing VPC
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

# 2. Look up the existing App Security Group
data "aws_security_group" "app_existing_sg" {
  filter {
    name   = "tag:Name"
    values = ["app-security-group"] 
  }
}

# 3. Look up the public subnet
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["public-subnet"] 
  }
}

resource "aws_instance" "app_server_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  subnet_id = data.aws_subnets.public.ids[0]
  vpc_security_group_ids = [data.aws_security_group.app_existing_sg.id]
  
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  
  associate_public_ip_address = true

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "app-server-ec2"
  }
}
