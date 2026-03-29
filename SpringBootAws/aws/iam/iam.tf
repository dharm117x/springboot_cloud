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
  name   = "s3-ec2-access-policy"
  policy = templatefile("${path.module}/policies/s3-policy.json", { bucket_arn = var.s3_bucket_arn })
}

resource "aws_iam_policy" "sqs_policy" {
  name   = "sqs-ec2-access-policy"
  policy = templatefile("${path.module}/policies/sqs-policy.json", { 
    queue_arns = [var.sqs_order_queue_arn, var.sqs_user_queue_arn] 
  })
}

resource "aws_iam_policy" "sns_policy" {
  name   = "sns-ec2-access-policy"
  policy = templatefile("${path.module}/policies/sns-policy.json", { topic_arn = var.sns_topic_arn })
}

resource "aws_iam_policy" "rds_policy" {
  name   = "rds-ec2-access-policy"
  policy = templatefile("${path.module}/policies/rds-policy.json", { rds_arn = var.rds_instance_arn })
}

resource "aws_iam_policy" "ecr_read_policy" {
  name   = "ecr-read-access-policy"
  policy = templatefile("${path.module}/policies/ecr-policy.json", { ecr_repos_arn = var.ecr_repository_arn })
}

resource "aws_iam_policy" "cloudwatch_policy" {
  name   = "cloudwatch-logs-policy"
  policy = templatefile("${path.module}/policies/cloudwatch-logs-policy.json", {
    log_group_arn = var.log_group_arn
  })
}
  
#3.Attach S3 policy to Role
resource "aws_iam_role_policy_attachment" "attach_s3" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

#3.1 Attach Policies to Role
resource "aws_iam_role_policy_attachment" "attachments" {
  for_each = {
    sqs        = aws_iam_policy.sqs_policy.arn
    sns        = aws_iam_policy.sns_policy.arn
    rds        = aws_iam_policy.rds_policy.arn
    ecr_read   = aws_iam_policy.ecr_read_policy.arn
    cloudwatch = aws_iam_policy.cloudwatch_policy.arn
  }

  role       = aws_iam_role.ec2_role.name
  policy_arn = each.value
}
