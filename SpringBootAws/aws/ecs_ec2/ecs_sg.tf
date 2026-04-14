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
    description = "Allow all outbound"
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
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    description = "Allow all outbound (Required for RDS and VPC Endpoints)"
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

# 4. VPC Endpoints Security Group (FOR SQS & SNS)
# This allows the Interface Endpoints to accept traffic from your App
resource "aws_security_group" "vpc_endpoints_sg" {
  name        = "vpc-endpoints-sg"
  description = "Security group for SQS/SNS VPC Endpoints"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    description     = "Allow HTTPS from ECS Tasks"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_ec2_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "vpc-endpoints-sg" }
}

# SQS Endpoint
resource "aws_vpc_endpoint" "sqs" {
  vpc_id              = data.aws_vpc.existing_vpc.id
  service_name        = "com.amazonaws.${var.region}.sqs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.aws_subnets.public_subnets.ids
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  private_dns_enabled = true
}

# SNS Endpoint
resource "aws_vpc_endpoint" "sns" {
  vpc_id              = data.aws_vpc.existing_vpc.id
  service_name        = "com.amazonaws.${var.region}.sns"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = data.aws_subnets.public_subnets.ids
  security_group_ids  = [aws_security_group.vpc_endpoints_sg.id]
  private_dns_enabled = true
  
}

# The S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = data.aws_vpc.existing_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  # This automatically adds the "S3 shortcut" to your Route Tables
  route_table_ids = [
    data.aws_route_table.existing_public_rt.id,
    data.aws_route_table.existing_private_rt.id
  ]

  tags = {
    Name = "s3-gateway-endpoint"
  }
}

# Bridge Rule for Existing RDS (if applicable)
resource "aws_security_group_rule" "allow_ecs_to_rds" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = data.aws_security_group.rds_existing_sg.id
  source_security_group_id = aws_security_group.ecs_ec2_sg.id
}
