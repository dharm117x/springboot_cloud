# File: D:\...\aws_projects\outputs.tf

output "dev_bucket_id" {
  value = module.dev.bucket_name
}

output "staging_bucket_id" {
  value = module.staging.bucket_name
}

output "dev_instance_id" {
  value = module.dev.instance_ip_addr
}

output "staging_instance_id" {
  value = module.staging.instance_ip_addr
}
