# 1. Look up the existing VPC by its Name tag
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"] # Must match the Name tag in your VPC folder
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
    values = ["private-subnet-*"] # Matches private-subnet-1 and private-subnet-2
  }
}

# 3. Look up the existing RDS Security Group
data "aws_security_group" "existing_rds_sg" {
  filter {
    name   = "tag:Name"
    values = ["rds-multi-security-group"] # Must match Name tag in your SG folder
  }
}

# 4. Lookup up the DB Subnet Group (Required for RDS in a VPC)
data "aws_db_subnet_group" "existing_db_subnet_group" {
  name = "my-app-db-subnet-group" # This MUST match the 'name' attribute in your VPC file
}

# 5. The RDS Instance (Free Tier Config)
resource "aws_db_instance" "postgres" {
  identifier        = "postgres-db"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"      # Free Tier
  allocated_storage = 20                 # Free Tier
  storage_type      = "gp2"              # Free Tier

  db_name  = "mydb"
  username = "postgres"
  password = var.db_password             # Keep this in variables.tf

  # Network & Security
  db_subnet_group_name   = data.aws_db_subnet_group.existing_db_subnet_group.name
  vpc_security_group_ids = [data.aws_security_group.existing_rds_sg.id]
  
  publicly_accessible    = false         # Keeps it free and secure
  multi_az               = false         # Required for Free Tier
  skip_final_snapshot    = true          # Prevents charges on deletion

  tags = {
    Name = "Main-Postgres-DB"
  }
}
