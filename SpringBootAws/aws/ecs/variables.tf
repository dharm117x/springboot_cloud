variable "account_no" {}

variable "region" {
  default = "us-east-1"
}

variable "ecs_cluster_name" {
  default = "my-ecs-cluster"
}

variable "ecr_repository_url" {}

variable "docker_repository_url" {}

variable "s3_bucket_name" {
  default = "s3-java-pgm-mybucket"
}

variable "sns_topic_name" {
  default = "my-topic"
}

variable "sns_topic_arn" {}

variable "rds_resource_id" {
  default = "mysql-single-az-db"
}

variable "rds_endpoint" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}
