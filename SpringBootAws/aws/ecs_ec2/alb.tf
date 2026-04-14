# The physical Load Balancer-(Application Load Balancer)
resource "aws_lb" "app-lb" {
  name               = "ecs-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.public_subnets.ids

  tags = {
    Name = "ecs-alb"
  }
}

# The Target Group (Updated to match your 9001 port)
resource "aws_lb_target_group" "app_tg" {
  name        = "ecs-app-tg"
  port        = 9001
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.existing_vpc.id
  target_type = "ip"

  health_check {
    path                = "/actuator/health"
    port                = "9001"
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# The Listener (Now it can find aws_lb.app-lb)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
