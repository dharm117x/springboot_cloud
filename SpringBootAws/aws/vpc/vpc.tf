#1. Define the VPC with a CIDR block and enable DNS hostnames.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "main-vpc" }
}

#2. Create an Internet Gateway and attach it to the VPC.
resource "aws_internet_gateway" "igw" {
  vpc_id 				= aws_vpc.main.id
  tags   				= { Name = "main-igw" }
}

#3. Create two public subnets in different availability zones, and ensure they are associated with the route table that has a default route to the Internet Gateway.
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"
  tags                    = { Name = "public-subnet-1" }
}

#4. Create a second public subnet in a different availability zone to ensure high availability for your public resources.
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24" # New CIDR block
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b" # Different AZ
  tags                    = { Name = "public-subnet-2" }
}

#5. Create a route table for the public subnets and add a default route to the Internet Gateway.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

#6. Associate the public subnets with the route table to ensure they have internet connectivity.
resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_rt.id
}

#7. ADDED: Association for the second public subnet
resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_rt.id
}

#8. Create private subnets for your backend services.
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.region}a"
  tags              = { Name = "private-subnet-1" }
}

#9. Create a second private subnet in a different availability zone to ensure high availability for your backend services.
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.region}b" # Note the 'b' here
  tags              = { Name = "private-subnet-2" }
}


#10. Create a DB subnet group that includes the private subnets for your database instances.
resource "aws_db_subnet_group" "app_db_subnet_group" {
  name       = "my-app-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  
  tags = {
    Name = "My DB Subnet Group"
  }
}

# Disable default security group and NACL rules to enforce least privilege access
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
  # No ingress or egress rules defined = Deny All
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id
  # No ingress or egress rules defined = Deny All
}
