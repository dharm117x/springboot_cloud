variable "region" {
  default = "us-east-1"
}

variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}

variable "s3_bucket_arn" {
  type    = string
  default = "arn:aws:s3:::my-app-data-bucket"
}

variable "sqs_queue_arn" {
  type    = string
  default = ""
}

variable "sns_topic_arn" {
  type    = string
  default = ""
}

variable "rds_instance_arn" {
  type    = string
  default = ""
}
