# Find the main VPC
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

# Find BOTH public subnets (for ALB/EC2)
data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["public-subnet-*"] # Matches public-subnet-1 and public-subnet-2
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["private-subnet-*"] # Matches public-subnet-1 and public-subnet-2
  }
}

# Find the Security Group
data "aws_security_group" "app_existing_sg" {
  filter {
    name   = "tag:Name"
    values = ["app-security-group"] 
  }
}

data "aws_security_group" "rds_existing_sg" {
  filter {
    name   = "tag:Name"
    values = ["rds-multi-port-sg"] 
  }
}

