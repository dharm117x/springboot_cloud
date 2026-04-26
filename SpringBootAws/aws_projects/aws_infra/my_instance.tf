resource "aws_instance" "ec2" {
  instance_type = var.instance_type
  ami           = var.ami_id
  count         = var.instance_count
  key_name      = var.key_name

  tags = {
    Name        = "${var.my-env}-ec2-instance-${count.index + 1}"
    Environment = var.my-env
  }

}
