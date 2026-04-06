provider "aws" {
  region = "us-east-1"
}

# Get AWS Account ID (for secure policy)
data "aws_caller_identity" "current" {}

# 1. SNS Topic
resource "aws_sns_topic" "my_topic" {
  name = "my-topic"

  tags = {
    Environment = "dev"
  }
}

# 2. SQS Queue - User
resource "aws_sqs_queue" "my_user" {
  name = "my-user-queue"

  tags = {
    Environment = "dev"
  }
}

# 2.1 DLQ
resource "aws_sqs_queue" "my_order_dlq" {
  name                      = "my-order-queue-dlq"
  message_retention_seconds = 1209600

  tags = {
    Environment = "dev"
  }
}

# 2.2 Main Order Queue
resource "aws_sqs_queue" "my_order" {
  name = "my-order-queue"

  visibility_timeout_seconds = 60  # increased (best practice)

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.my_order_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Environment = "dev"
  }
}

# 2.3 Redrive allow policy
resource "aws_sqs_queue_redrive_allow_policy" "dlq_policy" {
  queue_url = aws_sqs_queue.my_order_dlq.id

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = [aws_sqs_queue.my_order.arn]
  })
}

# 2.4 CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "dlq_alarm" {
  alarm_name          = "dlq-message-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    QueueName = aws_sqs_queue.my_order_dlq.name
  }

  alarm_description = "Alert when DLQ has messages"
}

# 3. Subscriptions
resource "aws_sns_topic_subscription" "user_sub" {
  topic_arn            = aws_sns_topic.my_topic.arn
  protocol             = "sqs"
  endpoint             = aws_sqs_queue.my_user.arn
  filter_policy        = file("${path.module}/policies/filter_policy.json")
  raw_message_delivery = true

  depends_on = [aws_sqs_queue_policy.sns_publish_policy]
}

resource "aws_sns_topic_subscription" "order_sub" {
  topic_arn  = aws_sns_topic.my_topic.arn
  protocol   = "sqs"
  endpoint   = aws_sqs_queue.my_order.arn

  filter_policy = jsonencode({
    "eventType" = ["OrderType"]
  })

  raw_message_delivery = true

  depends_on = [aws_sqs_queue_policy.sns_publish_policy]
}

# 4. Queue Policy (SNS → SQS)
resource "aws_sqs_queue_policy" "sns_publish_policy" {
  for_each = {
    user  = { arn = aws_sqs_queue.my_user.arn, id = aws_sqs_queue.my_user.id }
    order = { arn = aws_sqs_queue.my_order.arn, id = aws_sqs_queue.my_order.id }
  }

  queue_url = each.value.id

  policy = templatefile("${path.module}/policies/access_policy.json", {
    sqs_arn    = each.value.arn
    sns_arn    = aws_sns_topic.my_topic.arn
    account_id = data.aws_caller_identity.current.account_id
  })
}
