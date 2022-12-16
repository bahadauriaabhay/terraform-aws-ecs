variable "enable_ecs_cluster" {
  type        = string
  default     = true
  description = "true will create AWS cluster and false will use existing cluster name (ecs_clustername = ) "
}

variable "enable_ecs_host" {
  type    = string
  default = true
}

variable "enable_asg_sg" {
  type        = string
  default     = true
  description = "true will create security group for autoscalling group and false will use existing security group by passing list of security group id  (asg_sg =) "
}

variable "enable_asg_sgALB" {
  type        = string
  default     = true
  description = "true will create security group for Application LB and false will use existing security group by passing security group id  (sgALB =) "
}
variable "enable_alb" {
  type        = string
  default     = true
  description = "true will create Application LB and false will use existing ALB by passing (alb_name =) "
}
variable "enable_alb_listener" {
  type        = string
  default     = true
  description = "true will create aws_lb_listener and false will use existing aws_lb_listener "
}
variable "launch_type" {
  default     = "EC2"
  description = "The launch type on which to run your service. The valid values are EC2 and FARGATE. Defaults to EC2."
}
variable "fargate_only" {
  default     = "true"
  description = "create forgate only provider if launch_type=EC2 then fargate_only=false(will create fargate resource ,if launch_type=FARGATE then fargate_only=true )  "
}