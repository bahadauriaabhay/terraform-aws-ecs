
variable "myapp_1" {
  type = object({
    aws_region = string
    app_name       = string
    app_image      = string
    container_port = number
    tg_hc_path = string
    domain_name = string
    ecs_clustername = string
    desired_count = number
  })
}





























/* 
variable "myapp_td" {
  type = object({
   
  })
}

variable "myapp_alb" {
  type = object({
   
  })
}

variable "myapp_ecs" {
  type = object({
    
  })
   
}





/*variable "s3" {
  type = object ({
    s3_bucket_name = string
    
  })
  
}
*/





















 /* default = {
    desired_count = 1
  }*/ 
/*
  default = {
    tg_hc_path = "/"
    domain_name = "test.com"
  }
  */


/*
//  app_name       = "test"
   // app_image      = "743930152640.dkr.ecr.us-east-1.amazonaws.com/hawk-backend:generic-onboard"
   //  container_port = 80
   */

/* default = {
   
  }
  */





#defaut values have been set in .auto.tfvars




/*
variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}
variable "essential" {
}

variable "networkMode" {
  type = string
}

variable "host_port" {
  type = number
}

*/
#alb variables 
/*
variable "alb_name" {
  type = string

}*/
/*
variable "tg_port" {
  type = number

}
*/

/* variable "vpc_id" {
  type = string
}*/

/*
variable "tg_protocol" {
  type = string
}

variable "tg_type" {
  type = string
}

variable "tg_healthy_threshold" {
  type = number
}

variable "tg_hc_interval" {
  type = string
}

variable "tg_hc_protocol" {
  type = string
}

variable "tg_hc_matcher" {
  type = string
}

variable "tg_hc_timeout" {
  type = string
}

variable "tg_unhealthy_threshold" {
  type = string
}

*/
#ecs cluster variables


#ALB Listener Rule
/*
variable "alb_action_type" {
  type = string
}
*/ 
/* 
  default = {
    
  }

  default = {
    
  }
  */
