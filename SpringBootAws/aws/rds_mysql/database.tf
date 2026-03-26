# 1. Look up the existing VPC by its Name tag
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"]
  }
}

# 2. Look up the existing Private Subnets (needed for RDS)
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing_vpc.id]
  }
  filter {
    name   = "tag:Name"
    values = ["private-subnet-*"]
  }
}

# 3. Look up the existing RDS Security Group
data "aws_security_group" "existing_rds_sg" {
	name = "rds-multi-security-group"
}

# 4. Lookup up the DB Subnet Group (Required for RDS in a VPC)
data "aws_db_subnet_group" "existing_db_subnet_group" {
  name = "my-app-db-subnet-group"
}

# 5. The RDS Instance (Free Tier Config)
resource "aws_db_instance" "mysql_single_az" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.4.7"
  instance_class       = var.instance_class # Common for single-AZ/dev setups
  identifier           = "my-single-az-db"
  username             = "admin"
  password             = var.db_password
  
  # Ensure Multi-AZ is disabled
  multi_az             = false
  
  # Optional: Lock it to a specific AZ
  availability_zone    = var.region

  db_subnet_group_name   = data.aws_db_subnet_group.existing_db_subnet_group.name
  vpc_security_group_ids = [data.aws_security_group.existing_rds_sg.id]
  
  skip_final_snapshot    = true
}
