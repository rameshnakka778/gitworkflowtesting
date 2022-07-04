terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.2.0"
    }  
  }
}

provider "aws" {
    region = var.my_region
    profile = var.my_profile
}
terraform {
  backend "s3" {
  }
}