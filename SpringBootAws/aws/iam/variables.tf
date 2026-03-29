variable "region" {
  default = "us-east-1"
}

variable "s3_bucket_arn" {}
variable "rds_instance_arn" {}
variable "ecr_repository_arn" {}

variable "sns_topic_arn" {}
variable "sqs_order_queue_arn" {}
variable "sqs_user_queue_arn" {}
variable "log_group_arn" {}


