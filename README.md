# terraform-aws-infra

A comprehensive Infrastructure as Code (IaC) project that provisions secure, scalable AWS infrastructure using Terraform modules. This project demonstrates best practices for cloud infrastructure provisioning 

## 🏗️ What This Project Does

This Terraform project creates a complete AWS infrastructure stack including:

- **Virtual Private Cloud (VPC)** with public and private subnets across multiple Availability Zones
- **EC2 instances** for standalone compute resources
- **Auto Scaling Group (ASG)** with dynamic scaling based on CPU utilization
- **S3 bucket** for Terraform state storage with versioning and encryption
- **DynamoDB table** for Terraform state locking
- **Security Groups** with least-privilege access controls

## 🛠️ Technologies Used

### Core Infrastructure
- **Terraform** (>= 1.0) - Infrastructure as Code tool
- **AWS Provider** (~> 5.0) - AWS resource management

### Development Tools
- **AWS CLI** - AWS command line interface
- **Git** - Version control

## 📋 Prerequisites

Before you begin, ensure you have the following installed and configured:

1. **Terraform** (>= 1.0)
   ```bash
   # Install Terraform
   curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
   sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
   sudo apt-get update && sudo apt-get install terraform
   ```

2. **AWS CLI** (>= 2.0)
   ```bash
   # Install AWS CLI
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```

3. **AWS Account** with appropriate permissions for:
   - VPC, EC2, S3, DynamoDB, CloudWatch, IAM
   - Programmatic access (Access Key ID and Secret Access Key)

## ⚙️ Setup Instructions

### 1. Clone the Repository
```bash
git clone https://github.com/ellabella96/terraform-aws-infra.git
cd terraform-aws-infra
```

### 2. Configure AWS Credentials
Choose one of the following methods:

**Option A: AWS CLI Configuration (Recommended)**
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Enter your default region (e.g., us-east-1)
# Enter output format (json)
```

**Option B: Environment Variables**
```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### 3. Customize Configuration

#### Create Environment-Specific Variable Files
```bash
# Create development environment variables
cp terraform.tfvars.example terraform.tfvars

# Edit the file with your specific values
nano terraform.tfvars
```

#### Example `terraform.tfvars`:
# Environment Configuration
aws_region = "us-east-1"
environment = "dev"
project_name = "terraform-aws-infra"

# Network Configuration
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# Instance Configuration
instance_type = "t3.micro"
key_pair_name = "your-key-pair"  # Optional

# Auto Scaling Configuration
enable_alb_asg = true
asg_min_size = 1
asg_max_size = 3
asg_desired_capacity = 2


# Tags
common_tags = {
  Environment = "dev"
  Project     = "terraform-aws-infra"
  ManagedBy   = "terraform"
  Owner       = "your-name"
}
```

### 4. Update Backend Configuration (Optional)

If using remote state storage, update the backend configuration in `main.tf`:

terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "your-terraform-locks"
    encrypt        = true
  }
}
```

## 🚀 How to Run

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Validate Configuration
```bash
terraform validate
```

### 3. Plan Infrastructure
```bash
# Plan with specific environment
terraform plan -var-file="terraform.tfvars"

# Or with default values
terraform plan
```

### 4. Apply Infrastructure
```bash
# Apply with specific environment
terraform apply -var-file="terraform.tfvars"

# Or with default values
terraform apply
```
Visit the URL in your browser to see your deployed application.


## 🔧 Available Commands

```bash
# View current infrastructure
terraform show

# List all resources
terraform state list

# Get specific output
terraform output vpc_id

# Format code
terraform fmt

# Destroy infrastructure
terraform destroy -var-file="terraform.tfvars"

# Import existing resource
terraform import aws_instance.example i-1234567890abcdef0
```

## 🌍 Multi-Environment Support

Deploy to different environments using environment-specific variable files:

```bash
# Development
terraform apply -var-file="dev.tfvars"

# Staging
terraform apply -var-file="staging.tfvars"

# Production
terraform apply -var-file="prod.tfvars"
```


## 🚨 Important Notes

1. **Costs**: This infrastructure will incur AWS charges. Monitor your usage and destroy resources when not needed.

2. **State Management**: Always use remote state storage for production environments.

3. **Security**: Never commit AWS credentials to version control.

4. **Key Pairs**: Create an EC2 key pair in your AWS region if you need SSH access to instances.

5. **Cleanup**: Run `terraform destroy` to avoid ongoing charges when done testing.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request



## 📞 Support

If you encounter any issues or have questions:

1. Check the [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
2. Review AWS service documentation
3. Open an issue in this repository

## 🙏 Acknowledgments

- HashiCorp for Terraform
- AWS for comprehensive cloud services
- The open-source community for continuous inspiration
