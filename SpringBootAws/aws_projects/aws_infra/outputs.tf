# aws_infra/outputs.tf

output "bucket_name" {
  value = aws_s3_bucket.my_bucket.id
}

output "instance_ip_addr" {
  value = aws_instance.ec2[*].public_ip # Or however you defined your instance
}
