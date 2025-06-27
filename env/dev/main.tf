# VPC Module
module "vpc" {
  source = "../../modules/vpc"

  project_name           = var.project_name
  environment           = var.environment
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
}

# S3 Module
module "s3_app_data" {
  source = "../../modules/s3"

  project_name      = var.project_name
  environment       = var.environment
  bucket_purpose    = "app-data"
  enable_versioning = true
  enable_lifecycle  = true
}

# DynamoDB Module
module "dynamodb_app" {
  source = "../../modules/dynamodb"

  project_name  = var.project_name
  environment   = var.environment
  table_purpose = "app-data"
  hash_key      = "id"
  
  attributes = [
    {
      name = "id"
      type = "S"
    }
  ]
}

# EC2 Module (without ALB/ASG)
module "ec2" {
#  count = var.enable_alb_asg ? 0 : 1
  source = "../../modules/ec2"

  project_name         = var.project_name
  environment          = var.environment
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnet_ids
  instance_type       = var.instance_type
  instance_count      = var.instance_count
  key_pair_public_key = var.key_pair_public_key
  allowed_ssh_cidrs   = ["0.0.0.0/0"]  # Restrict this in production!
}
