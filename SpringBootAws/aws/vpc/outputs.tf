output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  value = [
    aws_subnet.public.id,
    aws_subnet.private_1.id,
    aws_subnet.private_1.id
  ]
}