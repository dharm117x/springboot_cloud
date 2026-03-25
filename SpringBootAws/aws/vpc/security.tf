# 1. Security Group for EC2 (App Server)
resource "aws_security_group" "app_sg" {
  name   = "app-security-group"
  vpc_id = aws_vpc.main.id # Use the resource link from your VPC file
  tags   = { Name = "app-security-group" }
}

# Fetch your local IP automatically
data "http" "my_ip" {
  url = "http://checkip.amazonaws.com/"
}

# Rule: SSH (Restricted to your IP only - very secure!)
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  security_group_id = aws_security_group.app_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["${chomp(data.http.my_ip.response_body)}/32"]
}

# Rule: Web Traffic (80, 443, 8080, 9001)
resource "aws_security_group_rule" "web_traffic" {
  for_each          = toset(["80", "443", "8080", "9001"])
  type              = "ingress"
  security_group_id = aws_security_group.app_sg.id
  from_port         = each.value
  to_port           = each.value
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Rule: Egress (Allow EC2 to talk to Internet/AWS Services)
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  security_group_id = aws_security_group.app_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

# 2. Security Group for RDS (Database)
resource "aws_security_group" "rds_sg" {
  name        = "rds-db-sg"
  description = "Allow traffic from EC2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5432 # Change to 3306 if using MySQL
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "rds-security-group" }
}
