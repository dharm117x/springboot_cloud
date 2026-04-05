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
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    # Dynamically use the full list of IDs from your data lookups
    subnets          = data.aws_subnets.public_subnets.ids
    security_groups  = [data.aws_security_group.app_existing_sg.id, data.aws_security_group.rds_existing_sg.id]    
    assign_public_ip = true 
  }

  # ADDED: Load Balancer Block
  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "springboot-container" # Must match the 'name' in your container-def.json
    container_port   = 9001             # Your Spring Boot Port
  }

  # Ensure IAM and ALB Listener are ready first
  depends_on = [
    aws_iam_role_policy_attachment.ecs_execution_attach,
    aws_lb_listener.http
  ]
}
