variable "ecs_clustername" {
  description = "Name of this ECS cluster."
  default     = "ecs_clustername"
}


#variable "myapp_1" {
#   type = object({
#     aws_region = string
#     app_name       = string
#     app_image      = string
#     container_port = number
#     tg_hc_path = string
#     domain_name = string
#     ecs_clustername = string
#     desired_count = number
#   })
# }

variable "container_definitions" {
  type = map(object({
    name      = string
    image     = string
    cpu       = number
    memory    = number
    essential = bool
    portMappings = map(object({
      containerPort = number
      hostPort      = number
    }))
  }))
  default = {
    "key" = {
      cpu       = "512"
      essential = "true"
      image     = "nginx"
      memory    = "512"
      name      = "app-demo1"
      portMappings = {
        "key" = {
          containerPort = 80
          hostPort      = 80
        }
      }
    }
  }
  #default = [ {
  #  cpu = "512"
  #  essential = "true"
  #  image = "nginx"
  #  memory = "512"
  #  name = "app-demo1"
  #  portMappings = [{containerPort = "80" , hostPort = "80"}]
  #} ]
}



#variable "networkMode" {
#  type = string
#  default = "bridge"
#}

variable "container_port" {
  type    = number
  default = 80
}
variable "container_cpu" {
  type    = number
  default = 100
}
variable "container_memory" {
  type    = number
  default = 512
}

variable "host_port" {
  type    = number
  default = 0
}

#alb variables
variable "alb_name" {
  type    = string
  default = ""
}
#variable "alb" {
#  default = true
#  description = "Create an ALB"
#}
variable "alb_arn" {
  description = "Use alb provided"
  default     = "example"
}

/*
variable "tg_name" {
    type = string
    default = "ecs-target-group" 
}
*/
variable "tg_port" {
  type    = number
  default = 80
}



variable "tg_protocol" {
  type    = string
  default = "HTTP"
}

variable "tg_type" {
  type    = string
  default = "instance"
}

variable "tg_healthy_threshold" {
  type    = number
  default = 3
}

variable "tg_hc_interval" {
  type    = string
  default = "30"
}

variable "tg_hc_protocol" {
  type    = string
  default = "HTTP"
}

variable "tg_hc_matcher" {
  type    = string
  default = "200"

}

variable "tg_hc_timeout" {
  type    = string
  default = "3"
}

variable "tg_hc_path" {
  type    = string
  default = "/"
}

variable "tg_unhealthy_threshold" {
  type    = string
  default = "2"
}


#ecs cluster variables
#variable "ecs_clustername" {
#  type = string
#}

variable "desired_count" {
  type    = number
  default = 1
}

#ALB Listener Rule
/*
variable "alb_listener_arn" {
  type    = string
  default = "arn:aws:elasticloadbalancing:us-west-2:963021055388:listener/app/my-alb/67cfdb4cc96084a7/e57fd7922a5764e8"
}
*/

/*
variable "alb_listener_priority" {
  type = number
}
*/
variable "alb_action_type" {
  type    = string
  default = "forward"
}

#variable "domain_name" {
#  type = string
#  
#}

variable "name" {
  default = "demo1"
}
#variable "asg_arn" {
#   default = aws_autoscaling_group.asg.arn
#}
variable "asg_max" {
  default = 3
}
variable "asg_min" {
  default = 1
}
variable "health_check_type" {
  default = "ELB"
}
variable "desired_capacity" {
  default = 1
}
variable "force_delete" {
  default = "true"
}
variable "instance_types" {
  default = "t2.micro"
}
#variable "asg_sg" { 
#}

variable "vpc_zone_id" {
  default = []
}
variable "health_check_grace_period" {
  default = 300
}
variable "image_id" {
  default = "ami-0fe77b349d804e9e6"
}

variable "vpc_cidr" {
  default = ["10.0.0.0/16"]
}

#variable "name" {
#  
#}
variable "from_port" {
  default = "80"
}
variable "to_port" {
  default = "80"
}


#variable "sg_vpc_id" {
#
#}
#variable "target_group_arn" {
#  #default = "aws_alb_target_group.ecs-target-group.id"
#}


variable "network_mode" {
  default     = null
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. (REQUIRED IF 'LAUCH_TYPE' IS FARGATE)"
}

variable "autoscaling_cpu" {
  default     = false
  description = "Enables autoscaling based on average CPU tracking"
}

variable "autoscaling_memory" {
  default     = false
  description = "Enables autoscaling based on average Memory tracking"
}

variable "autoscaling_max" {
  default     = 3
  description = "Max number of containers to scale with autoscaling"
}

variable "autoscaling_min" {
  default     = 1
  description = "Min number of containers to scale with autoscaling"
}

variable "autoscaling_target_cpu" {
  default     = 50
  description = "Target average CPU percentage to track for autoscaling"
}

variable "autoscaling_target_memory" {
  default     = 90
  description = "Target average Memory percentage to track for autoscaling"
}

variable "autoscaling_scale_in_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale in events"
}

variable "autoscaling_scale_out_cooldown" {
  default     = 300
  description = "Cooldown in seconds to wait between scale out events"
}
variable "sgALB" {
    type    = tuple ([string, string])
  default = ["example", "sample"]
}
variable "asg_sg" {
  default = "example"
}

variable "public_sub" {
  type    = tuple ([string, string])
  default = [""]
  description = "paas two public subnet for ALB [subnet1, subnet2]"
}
variable "vpc_id" {
  type    = string
  default = ""
}
variable "vpc_zone_id" {
  type    = tuple ([string, string])
  default = [""]
  description = "paas two private subnet for auto scalling group [subnet1, subnet2]"
}
