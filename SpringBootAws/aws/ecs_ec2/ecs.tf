provider "aws" {
  region = var.region
}

#ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

# ECS capability for EC2 launch type
resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn
  
    managed_scaling {
      status = "ENABLED"
      target_capacity = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 1000
    }
  }

}

# Associate the capacity provider with the cluster
resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name]
  default_capacity_provider_strategy {
    base = 1
    weight = 100
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
  }
}

# ECS TASK DEFINITION
resource "aws_ecs_task_definition" "ecs_task" {
  family       = "springboot-app"
  network_mode = "awsvpc"
  requires_compatibilities = ["EC2"]
  memory          = 512
  cpu             = 512
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
  
  volume {
    name      = "host_logs"
    host_path = "/var/log/springboot-app"
  }
  
  container_definitions = templatefile("${path.module}/policies/container-def.json", {
    log_group_name     = aws_cloudwatch_log_group.ecs_logs.name
    image_url          = var.docker_repository_url
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

# ECS SERVICE
resource "aws_ecs_service" "ecs_ec2_service" {
  name            = "springboot-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 1
  
  network_configuration {
    subnets         = data.aws_subnets.public_subnets.ids
    security_groups = [aws_security_group.ecs_ec2_sg.id]
    assign_public_ip = false 
  }

  capacity_provider_strategy {
   capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight = 100 
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "springboot-container"
    container_port   = 9001
  }
# THIS PREVENTS "UNKNOWN" DURING STARTUP
  health_check_grace_period_seconds = 120 

  # Ensure the service waits for the Capacity Provider to be ready
  depends_on = [aws_lb_listener.http, aws_ecs_cluster_capacity_providers.cluster_capacity_providers]
  
}

# CLOUDWATCH LOGS
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/springboot-app"
  retention_in_days = 7
}
