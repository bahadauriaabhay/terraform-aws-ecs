
variable "app_name" {
  type = string
}
variable "app_image" {
  type = string
}

variable "cpu" {
  type = number
  default = 512
}
variable "memory" {
  type = number
  default = 512
}
variable "essential" {
  type = bool
  default = true
}

variable "networkMode" {
  type = string
  default = "bridge"
}

variable "container_port" {
  type = number
}

variable "host_port" {
  type = number
  default = 0
}

#alb variables
variable "alb_name" {
  type = string
  default = "my-alb" 
}

/*
variable "tg_name" {
    type = string
    default = "ecs-target-group" 
}
*/
variable "tg_port" {
  type = number
  default = 80
}

variable "vpc_id" {
  type = string
  default = "vpc-04f38cbe913c1555d" 
}

variable "tg_protocol" {
  type = string
  default = "HTTP"
}

variable "tg_type" {
  type = string
  default = "instance"
}

variable "tg_healthy_threshold" {
  type = number
  default = 3
}

variable "tg_hc_interval" {
  type = string
  default = "30"
}

variable "tg_hc_protocol" {
  type = string
  default = "HTTP"
}

variable "tg_hc_matcher" {
  type = string
  default = "200"

}

variable "tg_hc_timeout" {
  type = string
  default = "3"
}

variable "tg_hc_path" {
  type = string
}

variable "tg_unhealthy_threshold" {
  type = string
  default = "2"
}


#ecs cluster variables
variable "ecs_clustername" {
  type = string
}

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

variable "domain_name" {
  type = string
  
}