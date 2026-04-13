# 1. ECS Container Instance Role & Profile (The EC2 hosts themselves)
resource "aws_iam_role" "ecs_ec2_role" {
  name = "ecs-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Attach the required AWS managed policy for EC2-to-ECS communication
resource "aws_iam_role_policy_attachment" "ecs_ec2_attach" {
  role       = aws_iam_role.ecs_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# Create the Instance Profile that gets attached to the EC2 Launch Template/Configuration
resource "aws_iam_instance_profile" "ecs_ec2_profile" {
  name = "ecs-ec2-profile"
  role = aws_iam_role.ecs_ec2_role.name
}

# 2. Task Execution Role (For pulling images from ECR and sending logs)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# 3. Task Role (For application-level permissions like S3, SQS, etc.)
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-app-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "app_permissions" {
  name = "app-permissions"
  policy = templatefile("${path.module}/policies/app-permissions-policy.json", {
    region          = var.region
    account_no      = var.account_no
    s3_bucket_name  = var.s3_bucket_name
    sqs_queue_name  = var.sqs_queue_name
    sns_topic_name  = var.sns_topic_name
    rds_resource_id = var.rds_resource_id
  })
}

resource "aws_iam_role_policy_attachment" "task_permissions_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.app_permissions.arn
}
