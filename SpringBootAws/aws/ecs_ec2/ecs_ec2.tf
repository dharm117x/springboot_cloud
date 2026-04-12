provider "aws" {
  region = var.region
}

############################################
# ECS CLUSTER
############################################
resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}

############################################
# CLOUDWATCH LOGS
############################################
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/springboot-app"
  retention_in_days = 7
}

data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

############################################
# LAUNCH TEMPLATE (EC2 NODES)
############################################
resource "aws_launch_template" "ecs" {
  name_prefix   = "ecs-node"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  vpc_security_group_ids = [
    data.aws_security_group.ecs_app_sg.id
  ]

  user_data = base64encode(<<EOF
  #!/bin/bash
  echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
  yum install -y ecs-init
  systemctl enable ecs
  systemctl start ecs
  EOF
  )

  tags = {
    Name = "ECS Ec2 Node"
  }
}

############################################
# AUTO SCALING GROUP
############################################
resource "aws_autoscaling_group" "ecs_asg" {
  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  vpc_zone_identifier = data.aws_subnets.private_subnets.ids

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }


}

############################################
# TASK DEFINITION
############################################
resource "aws_ecs_task_definition" "ecs_task" {
  family       = "springboot-app"
  network_mode = "awsvpc"

  requires_compatibilities = ["EC2"]
  memory          = 512
  cpu             = 256
  
  container_definitions = templatefile("${path.module}/policies/container-def.json", {
    log_group_name     = aws_cloudwatch_log_group.ecs_logs.name
    image_url		       = var.ecr_repository_url
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

############################################
# ECS SERVICE (FIXED)
############################################
resource "aws_ecs_service" "ecs_ec2_service" {
  name            = "springboot-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  desired_count   = 2
  launch_type     = "EC2"
  
  network_configuration {
    subnets = data.aws_subnets.private_subnets.ids

    security_groups = [
      data.aws_security_group.ecs_sg.id
    ]

    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "springboot-container"
    container_port   = 9001
  }

  depends_on = [
    aws_lb_target_group.app_tg
  ]
}