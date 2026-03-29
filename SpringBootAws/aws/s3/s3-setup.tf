# 1. The Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "s3-java-pgm-mybucket"
}

# 2. Block Public Access (Optional but recommended for private buckets)
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
