 resource "aws_security_group" "alb_sg" {
  name   = "ecs-alb-sg"
  vpc_id = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-alb-sg"
  }
}

# ECS Security Group - Only allow traffic from ALB
resource "aws_security_group" "ecs_ec2_sg" {
  name   = "ecs-ec2-sg"
  vpc_id = data.aws_vpc.existing_vpc.id

  # ONLY allow ALB to talk to ECS
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Recommendation: Use your specific "Public_IP/32" instead
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-ec2-sg"
  }
}


# RDS Security Group - Only allow traffic from ECS 
resource "aws_security_group" "ecs_rds_sg" {
  name   = "ecs-rds-sg"
  vpc_id = data.aws_vpc.existing_vpc.id

  # ONLY allow ECS to talk to RDS
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-rds-sg"
  }
}
