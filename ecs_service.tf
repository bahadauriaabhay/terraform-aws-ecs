terraform {
  required_version = ">=0.12"
}

data "template_file" "myapp-task-definition-template" {
  template = file("../../../templates/ecs/app1.json.tpl")
  for_each  = var.container_definitions
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
  for_each  = var.container_definitions
    container_definitions = jsonencode([
    {
      name      = each.value['name']
      image     = each.value['image']
      cpu       = each.value['cpu']
      memory    = each.value['memory']
      essential = each.value['essential']
      portMappings = [
        {
          containerPort = 0
          hostPort      = 80
        }
      ]
    }
  ]
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



resource "aws_appautoscaling_target" "ecs" {
  count              = var.autoscaling_cpu || var.autoscaling_memory ? 1 : 0
  max_capacity       = var.autoscaling_max
  min_capacity       = var.autoscaling_min
  resource_id        = "service/${var.name}/${aws_ecs_service.ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_cpu" {
  count              = var.autoscaling_cpu ? 1 : 0
  name               = "scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.autoscaling_target_cpu
    disable_scale_in   = false
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "scale_memory" {
  count              = var.autoscaling_memory ? 1 : 0
  name               = "scale-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.autoscaling_target_memory
    disable_scale_in   = false
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}