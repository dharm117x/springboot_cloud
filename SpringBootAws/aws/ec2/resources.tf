# Create the S3 Bucket
resource "aws_s3_bucket" "app_bucket" {
  bucket = "s3-ec2-pgm-mybucket"
}

# 2. Block Public Access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.app_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create the SQS Queue
resource "aws_sqs_queue" "app_queue" {
  name = "my-app-queue"
}

# Create the SNS Topic
resource "aws_sns_topic" "app_topic" {
  name = "my-app-topic"
}
