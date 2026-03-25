#1.IAM Setup
resource "aws_iam_role" "ec2_role" {
  name = "ec2-app-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

#2. Attach Custom Policies
resource "aws_iam_policy" "s3_policy" {
  name   = "s3-access-policy"
  policy = templatefile("${path.module}/policies/s3-policy.json", { bucket_arn = var.s3_bucket_arn })
}

resource "aws_iam_policy" "sqs_policy" {
  name   = "sqs-access-policy"
  policy = templatefile("${path.module}/policies/sqs-policy.json", { queue_arn = var.sqs_queue_arn })
}

resource "aws_iam_policy" "sns_policy" {
  name   = "sns-access-policy"
  policy = templatefile("${path.module}/policies/sns-policy.json", { topic_arn = var.sns_topic_arn })
}

resource "aws_iam_policy" "rds_policy" {
  name   = "rds-access-policy"
  policy = templatefile("${path.module}/policies/rds-policy.json", { rds_arn = var.rds_instance_arn })
}


#3.Attach Policies to Role
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_sqs" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.sqs_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_sns" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.sns_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_rds" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.rds_policy.arn
}

#4.Instance Profile (Attach to EC2)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-app-profile"
  role = aws_iam_role.ec2_role.name
}
