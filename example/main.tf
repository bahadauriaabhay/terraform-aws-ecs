
module "ecs-appv1" {
  source = "../"

  #myapp task definition
  app_name       = var.myapp_1.app_name
  app_image      = var.myapp_1.app_image
  container_port = var.myapp_1.container_port

  # my app load balancer and vpc 

  tg_hc_path  = var.myapp_1.tg_hc_path
  domain_name = var.myapp_1.domain_name


  #ecs variables
  ecs_clustername = var.myapp_1.ecs_clustername
  desired_count   = var.myapp_1.desired_count

}































/*
  cpu            = var.cpu
  memory         = var.memory
  essential      = var.essential
  networkMode    = var.networkMode
  
 
  host_port      = var.host_port
*/
#alb variables 
/*
  tg_port                = var.tg_port
  
  tg_protocol            = var.tg_protocol
  tg_type                = var.tg_type
  tg_healthy_threshold   = var.tg_healthy_threshold
  tg_hc_interval         = var.tg_hc_interval
  tg_hc_protocol         = var.tg_hc_protocol
  tg_hc_matcher          = var.tg_hc_matcher
  tg_hc_timeout          = var.tg_hc_timeout
  */
/*
  tg_unhealthy_threshold = var.tg_unhealthy_threshold
  alb_action_type        = var.alb_action_type
*/

/* alb_listener_arn =var.alb_listener_arn

*/


