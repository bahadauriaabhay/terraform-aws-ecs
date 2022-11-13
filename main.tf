terraform {
  required_version = ">=0.12"
}

data "template_file" "myapp-task-definition-template" {
  template = file("../../../templates/ecs/app1.json.tpl")

  vars = {
    name          = var.app_name
    image         = var.app_image
    cpu           = var.cpu
    memory        = var.memory
    essential   =    var.essential
    networkMode = var.networkMode
    containerPort = var.container_port
    hostPort      = var.host_port
  }
}
 
resource "aws_ecs_task_definition" "myapp" {
  family = var.app_name
  container_definitions = data.template_file.myapp-task-definition-template.rendered
}
  /*container_definitions = jsonencode([
    {
      name        = var.app_name
      image       = var.app_image
      cpu         = var.cpu
      memory      = var.memory
      essential   = var.essential
      networkMode = var.networkMode
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
    },
    

  ])*/


data "aws_lb" "selected" {
  name = var.alb_name
}

data "aws_lb_listener" "selected80" {
  load_balancer_arn = data.aws_lb.selected.arn
  port              = 80
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


data "aws_ecs_cluster" "my-ecs-cluster" {
  cluster_name = var.ecs_clustername
}

resource "aws_ecs_service" "myapp-service" {
  name            = var.app_name
  cluster         = data.aws_ecs_cluster.my-ecs-cluster.id
  task_definition = aws_ecs_task_definition.myapp.arn
  desired_count   = var.desired_count

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-target-group.id
    container_name   = var.app_name
    container_port   = var.container_port
  }


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
