# Get the latest ECS-optimized AMI for Amazon Linux 2
data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}


# Create the Launch Template for ECS EC2 instances
resource "aws_launch_template" "ecs_ec2" {
  name_prefix   = "ecs-node-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = "t3.micro"
  key_name      = "Ec2_keyPair"

  # ADD THIS BLOCK FOR 10GB STORAGE
  block_device_mappings {
    device_name = "/dev/xvda" # Default root device for Amazon Linux 2

    ebs {
      volume_size = 30
      volume_type = "gp3" # gp3 is newer and usually cheaper/faster than gp2
      delete_on_termination = true
    }
  } 
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ecs_ec2_sg.id]
  }
  
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    cluster_name = aws_ecs_cluster.ecs_cluster.name
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {Name = "ecs-node"}
  }
}

# Auto Scaling Group for ECS EC2 instances
resource "aws_autoscaling_group" "ecs_asg" {
  name                = "ecs-asg"   
  vpc_zone_identifier = data.aws_subnets.public_subnets.ids

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }
 
  desired_capacity = 2
  max_size         = 2
  min_size         = 1
  
  health_check_type = "EC2"
  protect_from_scale_in = true

  # Ensure this tag is exactly like this for Capacity Providers to work
  tag {
    key                 = "AmazonECSManaged"
    value               = "true" 
    propagate_at_launch = true
  }
}