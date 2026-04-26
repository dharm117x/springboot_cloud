variable "my-env" {
    description = "Environment name (e.g., dev, staging, prod)"
    type = string
    default = "dev"
}

variable "bucket_name" {
    description = "Name of the S3 bucket (without environment prefix)"
    type = string
    default = "dk-s3-store-bucket"
}

variable "ami_id" {
    description = "AMI ID for the EC2 instance"
    type = string
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
    default = "t2.micro"  
}

variable "instance_count" {
    description = "Number of EC2 instances to launch"
    type = number
    default = 1
}

variable "key_name" {
    description = "Name of the SSH key pair"
    type = string
    default = "my-key-pair" 
}

