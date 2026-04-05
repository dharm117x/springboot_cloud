### 1. Public Subnet NACL (For ALB & ECS Tasks)
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.main.id
  # UPDATED: Includes both public subnets
  subnet_ids = [aws_subnet.public_1.id, aws_subnet.public_2.id]

  # Inbound: Allow HTTP (80) for ALB
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Inbound: Allow Spring Boot (8090) for ALB-to-Task or direct access
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 8090
    to_port    = 8090
  }

# Inbound: Allow SSH (22) for Admin Access (Optional, but useful for debugging)
 ingress {
    protocol   = "tcp"
    rule_no    = 115           # New rule number
    action     = "allow"
    cidr_block = "0.0.0.0/0"   # Or your specific IP for better security
    from_port  = 22
    to_port    = 22
  }

  # Inbound: Allow Return Traffic (Ephemeral Ports)
  # Essential for ALB health checks and container updates
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Outbound: Allow All (Needed for ALB to reach tasks and tasks to reach internet)
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = { Name = "public-nacl" }
}

### 2. Private Subnet NACL (For RDS)
resource "aws_network_acl" "private_nacl" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  # Inbound: Allow Database traffic from the ENTIRE Public Tier (10.0.1.0/24 & 10.0.4.0/24)
  # Using the VPC CIDR or specific subnet CIDRs is best practice
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16" # Allows any app task in the VPC to hit DB
    from_port  = 3306
    to_port    = 3306
  }

  # Outbound: Allow Return Traffic to VPC
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "10.0.0.0/16"
    from_port  = 1024
    to_port    = 65535
  }

  tags = { Name = "private-nacl" }
}
