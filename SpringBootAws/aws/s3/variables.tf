variable "region" {
  default = "us-east-1"
}

variable "env" {
  description = "env variable"
  default = "test"
  type = string
}

variable "bucket_name" {
  default = "dk-aws-java-bucket"
}
