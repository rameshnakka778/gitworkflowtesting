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
bucket = "aws-glue-target-poc-test"
region = "eu-west-1"
key = "dev/terraform.tfstate"
shared_credentials_file = "/home/dmehta/.aws/credentials"
}
}