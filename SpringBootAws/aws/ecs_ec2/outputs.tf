output "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "ecs_service_name" {
  description = "The name of the ECS service"
  value       = aws_ecs_service.ecs_ec2_service.name
}

output "task_definition_arn" {
  description = "The full ARN of the Task Definition"
  value       = aws_ecs_task_definition.ecs_task.arn
}

output "task_role_arn" {
  description = "The ARN of the IAM Task Role used by the Java application"
  value       = aws_iam_role.ecs_task_role.arn
}

output "alb_url" {
  description = "Application Load Balancer URL"
  value       = "http://${aws_lb.app-lb.dns_name}"
}