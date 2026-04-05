provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/springboot-app"
  retention_in_days = 7
}

# Task Definition
resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "springboot-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = templatefile("${path.module}/policies/container-def.json", {
    log_group_name     = aws_cloudwatch_log_group.ecs_logs.name
    ecr_repository_url = var.ecr_repository_url
    region             = var.region
    s3_bucket          = var.s3_bucket_name
    sqs_queue          = var.sqs_queue_name
    sns_topic          = var.sns_topic_name
    rds_endpoint       = var.rds_endpoint
    db_name            = var.db_name
    db_user            = var.db_user
    db_password        = var.db_password
  })
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "springboot-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    assign_public_ip = true
    security_groups  = var.security_group_ids # Pass as a variable
  }

  depends_on = [aws_iam_role_policy_attachment.ecs_execution_attach]
}
