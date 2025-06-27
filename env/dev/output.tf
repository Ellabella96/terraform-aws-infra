output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3_app_data.bucket_id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = module.dynamodb_app.table_name
}

# EC2 outputs (when not using ALB/ASG)
output "ec2_instance_ids" {
  description = "IDs of the EC2 instances"
  value       = var.enable_alb_asg ? [] : module.ec2.instance_ids  
}

output "ec2_public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = var.enable_alb_asg ? [] : module.ec2.instance_public_ips  
}
