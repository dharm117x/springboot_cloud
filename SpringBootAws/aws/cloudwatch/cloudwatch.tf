provider "aws" {
  region = var.region
}

resource "aws_cloudwatch_log_group" "cloudwatch-logs" {
  name              = var.log_group_name
  retention_in_days = 7
  
  tags = {
    Environment = "dev"
    Project     = "app-logging"
  }
}