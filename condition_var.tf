variable "enable_ecs_cluster" {
  type = string
  default = true
}

variable "enable_ecs_host" {
  type = string
  default = true
}

variable "enable_asg_sg" {
  type=string
  default= true
}
variable "enable_alb" {
  type=string
  default= true
}
variable "launch_type" {
  default     = "EC2"
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}
variable "fargate_only" {
  default = "true"
  description = "create forgate only provider if launch_type=EC2 then fargate_only=true (will create fargate resource ,if launch_type=FARGATE then fargate_only=false )  "
}