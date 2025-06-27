# VPC and Networking Variables
variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for Auto Scaling Group"
  type        = list(string)
}

# ALB Variables
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "main-alb"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

# Health Check Variables
variable "health_check_healthy_threshold" {
  description = "Number of consecutive health checks successes required before considering an unhealthy target healthy"
  type        = number
  default     = 2
}

variable "health_check_interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target"
  type        = number
  default     = 30
}

variable "health_check_matcher" {
  description = "Response codes to use when checking for a healthy responses from a target"
  type        = string
  default     = "200"
}

variable "health_check_path" {
  description = "Destination for the health check request"
  type        = string
  default     = "/"
}

variable "health_check_timeout" {
  description = "Amount of time, in seconds, during which no response means a failed health check"
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering the target unhealthy"
  type        = number
  default     = 2
}

# Auto Scaling Group Variables
variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = "main-asg"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2023 AMI (us-east-1)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair_name" {
  description = "Name of the AWS key pair for EC2 instances"
  type        = string
  default     = null
}

variable "asg_min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

# Security Variables
variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH to EC2 instances"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

# Auto Scaling Policy Variables
variable "scale_up_adjustment" {
  description = "Number of instances to add when scaling up"
  type        = number
  default     = 1
}

variable "scale_up_cooldown" {
  description = "Cooldown period (in seconds) after scaling up"
  type        = number
  default     = 300
}

variable "scale_down_adjustment" {
  description = "Number of instances to remove when scaling down"
  type        = number
  default     = -1
}

variable "scale_down_cooldown" {
  description = "Cooldown period (in seconds) after scaling down"
  type        = number
  default     = 300
}

# CloudWatch Alarm Variables
variable "high_cpu_threshold" {
  description = "CPU utilization threshold for scaling up"
  type        = number
  default     = 70
}

variable "low_cpu_threshold" {
  description = "CPU utilization threshold for scaling down"
  type        = number
  default     = 30
}

# User Data
variable "user_data" {
  description = "User data script for EC2 instances"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from $(hostname -f)</h1>" > /var/www/html/index.html
    EOF
}

# Common Tags
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "myapp"
    ManagedBy   = "terraform"
  }
}