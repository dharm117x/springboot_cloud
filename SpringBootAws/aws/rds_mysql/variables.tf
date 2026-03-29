variable "region" {
  default = "us-east-1"
}

variable "db_password" {
  description = "Database password"
  sensitive   = true
}

variable "availability_zone" {}
variable "instance_class" {}