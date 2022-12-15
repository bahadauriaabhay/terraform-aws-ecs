resource "aws_lb" "selected" {
  name = var.alb_name
  count  = var.enable_alb ? 1 : 0
  security_groups    = var.enable_asg_sgALB ? aws_security_group.aws_sgALB[0].id : var.sgALB
  subnets            = var.public_sub
}

resource "aws_lb_listener" "selected80" {
  count  = var.enable_alb_listener ? 1 : 0
  load_balancer_arn = var.enable_alb ? aws_lb.selected[0].arn : data.aws_lb.selected[0].arn 
  port              = 80
  protocol              = "HTTP"
  default_action {
    type                = "forward"
    target_group_arn    = var.enable_alb ? aws_lb.selected[0].arn : data.aws_lb.selected[0].arn
  }
}

data "aws_lb" "selected" {
  name = var.alb_name
  count  = var.enable_alb ? 0 : 1
}

data "aws_lb_listener" "selected80" {
  count  = var.enable_alb_listener ? 0 : 1
  load_balancer_arn = data.aws_lb.selected[0].arn
  port              = 80
  
}
#resource "aws_lb_listener_rule" "static" {
#  listener_arn = data.aws_lb_listener.selected80.arn
#  //priority     = var.alb_listener_priority
#
#  action {
#    type             = var.alb_action_type 
#    target_group_arn = aws_alb_target_group.ecs-target-group.arn
#  }
#
#  condition {
#    host_header {
#      values = [var.domain_name]
#      #values = ["example.com"]
#    }
#  }
#}

#resource "aws_lb_listener" "listener" {
#  load_balancer_arn     = var.alb ? aws_lb.test[0].arn : var.alb_arn
#  port                  = "80"
#  protocol              = "HTTP"
#
#  default_action {
#    type                = "forward"
#    target_group_arn    = aws_lb_target_group.test.arn
#  }
#}

resource "aws_alb_target_group" "ecs-target-group" {
  name        = "aws-lb-target-group-${var.name}"
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

