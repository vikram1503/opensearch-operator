 terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.57"
     }
  }
  backend "s3" {
    bucket = "imvicky"
    key    = "opensearch-dev-eks"
    region = "us-east-1"
    dynamodb_table = "terraform-remote-locking"
  }
}

provider "aws" {
  region= "us-east-1" 
}