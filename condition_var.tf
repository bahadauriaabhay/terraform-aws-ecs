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