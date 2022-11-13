terraform {
  backend "s3" {
    
    bucket         = "terraform-ecs-123"
    key            = "global/s3/ttn-apps/app1/terrform.tfstate"
    region         = "us-east-1"
    
    # Replace this with your DynamoDB table name!
    /*
    dynamodb_table = var.s3.dynamodb_name
    encrypt        = true
    */ 
  }
}
