# 1. ALB Security Group (The Gatekeeper)
resource "aws_security_group" "ecs_alb_sg" {
  name   = "ecs-alb-sg"
  vpc_id = data.aws_vpc.existing_vpc.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound to ECS tasks"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ecs-alb-sg" }
}

# 2. ECS EC2 Security Group (The Application)
resource "aws_security_group" "ecs_ec2_sg" {
  name   = "ecs-ec2-sg"
  vpc_id = data.aws_vpc.existing_vpc.id

  # Better Security: Only allow ALB to hit the Spring Boot port
  ingress {
    description     = "Allow traffic from ALB on Spring Boot port"
    from_port       = 9001
    to_port         = 9001
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_alb_sg.id]
  }
  
  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change to your IP for production
  }

  egress {
    description = "Allow all outbound (to Internet and RDS)"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ecs-ec2-sg" }
}

# 3. RDS Security Group (The Database)
resource "aws_security_group" "ecs_rds_sg" {
  name   = "ecs-rds-sg"
  vpc_id = data.aws_vpc.existing_vpc.id

  # This fixes your "Communications link failure"
  ingress {
    description     = "Allow MySQL traffic from ECS tasks"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ecs-rds-sg" }
}

# This bridges the gap between ECS and RDS
resource "aws_security_group_rule" "allow_ecs_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.rds_existing_sg.id # The RDS SG
  source_security_group_id = aws_security_group.ecs_ec2_sg.id          # Your ECS Task SG
}
