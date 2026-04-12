variable "account_no" {}
variable "ami_id" {}


variable "region" {
  default = "us-east-1"
}

variable "ecs_cluster_name" {
  default = "my-ecs-cluster"
}

variable "docker_repository_url" {}
variable "ecr_repository_url" {}

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
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
