set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BACKEND_DIR="$PROJECT_ROOT/backend-setup"

# Default values
PROJECT_NAME="myapp"
ENVIRONMENT="dev"
AWS_REGION="us-west-2"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--project-name)
      PROJECT_NAME="$2"
      shift 2
      ;;
    -e|--environment)
      ENVIRONMENT="$2"
      shift 2
      ;;
    -r|--region)
      AWS_REGION="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [OPTIONS]"
      echo "Options:"
      echo "  -p, --project-name    Project name (default: myapp)"
      echo "  -e, --environment     Environment (default: dev)"
      echo "  -r, --region          AWS region (default: us-west-2)"
      echo "  -h, --help           Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

echo "Setting up Terraform backend for:"
echo "  Project: $PROJECT_NAME"
echo "  Environment: $ENVIRONMENT"
echo "  Region: $AWS_REGION"
echo ""

# Check if AWS CLI is configured
if ! aws sts get-caller-identity >/dev/null 2>&1; then
    echo "Error: AWS CLI is not configured or credentials are invalid"
    echo "Please run 'aws configure' first"
    exit 1
fi

# Navigate to backend directory
cd "$BACKEND_DIR"

# Create terraform.tfvars for backend setup
cat > terraform.tfvars << EOF
project_name = "$PROJECT_NAME"
environment  = "$ENVIRONMENT"
aws_region   = "$AWS_REGION"
EOF

echo "Initializing Terraform..."
terraform init

echo "Planning Terraform changes..."
terraform plan -out=tfplan

echo "Applying Terraform changes..."
terraform apply tfplan

echo ""
echo "Backend setup complete!"
echo ""
echo "Next steps:"
echo "1. Note the S3 bucket name and DynamoDB table name from the output above"
echo "2. Update environments/$ENVIRONMENT/versions.tf with these values"
echo "3. Run 'terraform init' in your environment directory"
echo "4. Run 'terraform plan' and 'terraform apply' to create your infrastructure"

# Save outputs for easy reference
echo ""
echo "Saving backend configuration..."
S3_BUCKET=$(terraform output -raw s3_bucket_name)
DYNAMODB_TABLE=$(terraform output -raw dynamodb_table_name)

cat > backend-info.txt << EOF
# Backend Configuration for $PROJECT_NAME-$ENVIRONMENT
# Generated on $(date)

S3_BUCKET="$S3_BUCKET"
DYNAMODB_TABLE="$DYNAMODB_TABLE"
AWS_REGION="$AWS_REGION"

# Add this to your environments/$ENVIRONMENT/versions.tf:
#
# backend "s3" {
#   bucket         = "$S3_BUCKET"
#   key            = "$ENVIRONMENT/terraform.tfstate"
#   region         = "$AWS_REGION"
#   dynamodb_table = "$DYNAMODB_TABLE"
#   encrypt        = true
# }
EOF

echo "Backend information saved to backend-setup/backend-info.txt"
