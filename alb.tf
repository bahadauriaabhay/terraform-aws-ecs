data "aws_lb" "selected" {
  name = var.alb_name
}

data "aws_lb_listener" "selected80" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 80
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = data.aws_lb_listener.selected80.arn
  //priority     = var.alb_listener_priority

  action {
    type             = var.alb_action_type 
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
  }

  condition {
    host_header {
      values = [var.domain_name]
      #values = ["example.com"]
    }
  }
}

resource "aws_alb_target_group" "ecs-target-group" {
  name        = var.app_name
  port        = var.tg_port
  protocol    = var.tg_protocol
  vpc_id      = var.vpc_id
  target_type = var.tg_type

  health_check {
    healthy_threshold   = var.tg_healthy_threshold
    interval            = var.tg_hc_interval
    protocol            = var.tg_hc_protocol
    matcher             = var.tg_hc_matcher
    timeout             = var.tg_hc_timeout
    path                = var.tg_hc_path
    unhealthy_threshold = var.tg_unhealthy_threshold
  }
}