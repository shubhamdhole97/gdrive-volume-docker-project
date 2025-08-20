terraform {
  backend "s3" {
    bucket         = "tf-state-file-97"
    key            = "prod/terraform.tfstate" 
    region         = "ap-south-1"
    encrypt        = true
  }
}