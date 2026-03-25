output "public_ip" {
  value = aws_instance.app_server_ec2.public_ip
}