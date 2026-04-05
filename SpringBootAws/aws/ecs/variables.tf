variable "account_no" {}

variable "region" {
  default = "us-east-1"
}

variable "ecs_cluster_name" {
  default = "my-ecs-cluster"
}

variable "ecr_repository_url" {
  default = "<ACC_NO>.dkr.ecr.<REGION>.amazonaws.com/springboot-app:latest"
}

variable "s3_bucket_name" {
  default = "my-app-bucket"
}

variable "sqs_queue_name" {
  default = "my-order-queue"
}

variable "sns_topic_name" {
  default = "my-topic"
}

variable "rds_resource_id" {
  default = "mysql-single-az-db"
}

variable "rds_endpoint" {}

variable "db_name" {
  default = "app_db"
}

variable "db_user" {}

variable "db_password" {}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-020539286a15e9217"]
}

variable "security_group_ids" {
  type    = list(string)
  default = ["sg-0fc2735c3ebf24ef1","sg-0fd30cd7916007b3e"]
}
