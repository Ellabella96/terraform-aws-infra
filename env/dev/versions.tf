terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }

  backend "s3" {
    # Replace these values with your actual backend setup outputs
    bucket         = "myapp-terraform-state-dev-2b3d5f63"
    key            = "dev/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "myapp-terraform-state-lock-dev"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}
