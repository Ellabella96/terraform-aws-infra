#!/bin/bash
# complete-backend-cleanup.sh

PROJECT_NAME="myapp"  # Replace with your project name
ENVIRONMENT="dev"     # Replace with your environment

# Get resource names
S3_BUCKET=$(aws s3 ls | grep "${PROJECT_NAME}.*terraform-state.*${ENVIRONMENT}" | awk '{print $3}')
DYNAMODB_TABLE=$(aws dynamodb list-tables --query "TableNames[?contains(@, '${PROJECT_NAME}') && contains(@, 'terraform-state-lock') && contains(@, '${ENVIRONMENT}')]" --output text)

echo "Found resources:"
echo "S3 Bucket: $S3_BUCKET"
echo "DynamoDB Table: $DYNAMODB_TABLE"

if [ ! -z "$DYNAMODB_TABLE" ]; then
    echo "Cleaning up DynamoDB table: $DYNAMODB_TABLE"
    
    # Disable point-in-time recovery
    aws dynamodb update-continuous-backups \
        --table-name $DYNAMODB_TABLE \
        --point-in-time-recovery-specification PointInTimeRecoveryEnabled=false 2>/dev/null || true
    
    # Delete any backups
    aws dynamodb list-backups --table-name $DYNAMODB_TABLE --query 'BackupSummaries[].BackupArn' --output text | \
    xargs -I {} aws dynamodb delete-backup --backup-arn {} 2>/dev/null || true
    
    # Delete the table
    aws dynamodb delete-table --table-name $DYNAMODB_TABLE
    echo "Waiting for DynamoDB table deletion..."
    aws dynamodb wait table-not-exists --table-name $DYNAMODB_TABLE
fi

if [ ! -z "$S3_BUCKET" ]; then
    echo "Cleaning up S3 bucket: $S3_BUCKET"
    
    # Empty the bucket completely
    aws s3 rm s3://$S3_BUCKET --recursive
    
    # Delete all versions if versioning is enabled
    aws s3api delete-objects \
        --bucket $S3_BUCKET \
        --delete "$(aws s3api list-object-versions \
        --bucket $S3_BUCKET \
        --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' 2>/dev/null)" 2>/dev/null || true
    
    # Delete all delete markers
    aws s3api delete-objects \
        --bucket $S3_BUCKET \
        --delete "$(aws s3api list-object-versions \
        --bucket $S3_BUCKET \
        --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' 2>/dev/null)" 2>/dev/null || true
    
    # Delete the bucket
    aws s3 rb s3://$S3_BUCKET --force
fi

echo "Backend cleanup complete!"
