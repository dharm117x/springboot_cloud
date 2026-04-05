# This file defines the EC2 instance for the application server. It uses an existing security group and a specified AMI and instance type. The user data script is used to configure the instance on launch.
resource "aws_instance" "app_server_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  subnet_id = data.aws_subnets.public.ids[0]
  
  vpc_security_group_ids      = [data.aws_security_group.app_existing_sg.id]
  key_name                    = var.key_name
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "app-server-ec2"
  }
}
