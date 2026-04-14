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

# Rule: Web Traffic (80, 443, 8080, 8090, 9001)
resource "aws_security_group_rule" "web_traffic" {
  for_each          = toset(["80", "443", "8080","8090", "9001"])
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
locals {
  # List of default ports for MySQL, Oracle, and PostgreSQL
  db_ports = [3306, 1521, 5432]
}

resource "aws_security_group" "rds_multi_port_sg" {
  name        = "rds-multi-port-sg"
  description = "Allow inbound traffic for multiple database engines"
  vpc_id      = aws_vpc.main.id

  # Dynamic block to create an ingress rule for each port in local.db_ports
  dynamic "ingress" {
    for_each = local.db_ports
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      # Limits access to the specified application security group
      security_groups = [aws_security_group.app_sg.id]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-multi-port-sg"
  }
}
