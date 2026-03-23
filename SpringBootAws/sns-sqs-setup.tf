provider "aws" {
    region = "us-east-1"  # Set your desired AWS region
}

# 1. Create the SNS Topic
resource "aws_sns_topic" "my_topic" {
  name = "my-topic"
}

# 2. Create the SQS Queues
resource "aws_sqs_queue" "my_user" {
  name = "my-user-queue"
}

resource "aws_sqs_queue" "my_order" {
  name = "my-order-queue"
}

# 3. Subscriptions with Filter Policies
# User Queue: Filters for user-related events
resource "aws_sns_topic_subscription" "user_sub" {
  topic_arn     = aws_sns_topic.my_topic.arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.my_user.arn
  filter_policy = file("${path.module}/filter_policy.json")
  raw_message_delivery = true 
}

# Order Queue: Filters for order-related events
resource "aws_sns_topic_subscription" "order_sub" {
  topic_arn     = aws_sns_topic.my_topic.arn
  protocol      = "sqs"
  endpoint      = aws_sqs_queue.my_order.arn
  filter_policy = jsonencode({
    "eventType" = ["OrderType"]
  })
  raw_message_delivery = true 
}

# 4. Access Policies (Allow SNS to write to both queues)
resource "aws_sqs_queue_policy" "sns_to_sqs" {
  for_each = {
    user  = { arn = aws_sqs_queue.my_user.arn, id = aws_sqs_queue.my_user.id }
    order = { arn = aws_sqs_queue.my_order.arn, id = aws_sqs_queue.my_order.id }
  }

  queue_url = each.value.id

  # This "picks" the file and injects the correct ARN for each loop
  policy = templatefile("${path.module}/access_policy.json", {
    sqs_arn = each.value.arn
    sns_arn = aws_sns_topic.my_topic.arn
  })
}
