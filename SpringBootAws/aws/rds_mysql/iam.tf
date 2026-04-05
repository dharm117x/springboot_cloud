# Policy for app/EC2 instances to connect to RDS
resource "aws_iam_policy" "rds_policy" {
  name = "rds-ec2-access-policy"
  policy = templatefile("${path.module}/policies/rds-policy.json", { 
    rds_arn = aws_db_instance.mysql_single_az.arn 
  })
}

data "aws_iam_role" "existing_role" {
  name = "ec2-app-role"
}

# Attachment to the existing EC2 role
resource "aws_iam_role_policy_attachment" "attach_rds" {
  role       = data.aws_iam_role.existing_role.name
  policy_arn = aws_iam_policy.rds_policy.arn
}
