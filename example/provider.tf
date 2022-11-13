provider "aws" {
  /* shared_credentials_file = "$Home/.aws/credentials"
  profile                 = "default"
  */
  region = var.myapp_1.aws_region
}