#!/bin/bash

# Cloud Data Consulting Website Deployment Script
# Usage: ./deploy.sh [staging|production]

set -e  # Exit on any error

ENVIRONMENT=${1:-staging}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TERRAFORM_DIR="$PROJECT_ROOT/terraform"
SRC_DIR="$PROJECT_ROOT/src"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%Y-%m-%d %H:%M:%S')] WARNING: $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%Y-%m-%d %H:%M:%S')] ERROR: $1${NC}"
    exit 1
}

info() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

# Validate environment
if [[ "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
    error "Environment must be 'staging' or 'production'"
fi

log "Starting deployment for $ENVIRONMENT environment"

# Check if required tools are installed
command -v terraform >/dev/null 2>&1 || error "terraform is required but not installed"
command -v aws >/dev/null 2>&1 || error "aws CLI is required but not installed"

# Check if source directory exists
if [[ ! -d "$SRC_DIR" ]]; then
    error "Source directory $SRC_DIR does not exist"
fi

# Check if we have website files to deploy
if [[ ! -f "$SRC_DIR/index.html" ]]; then
    error "index.html not found in $SRC_DIR"
fi

# Setup AWS profile based on environment
if [[ "$ENVIRONMENT" == "staging" ]]; then
    DOMAIN="clouddataconsulting.io"
    AWS_PROFILE="cdc-prd"
    BACKEND_CONFIG="backend-staging.hcl"
    TFVARS="staging.tfvars"
else
    DOMAIN="clouddataconsulting.com"
    AWS_PROFILE="cdc-prd"
    BACKEND_CONFIG="backend-production.hcl"
    TFVARS="production.tfvars"
fi

log "Deploying $DOMAIN using AWS profile: $AWS_PROFILE"

# Check AWS credentials
info "Checking AWS credentials..."
if ! aws sts get-caller-identity --profile "$AWS_PROFILE" >/dev/null 2>&1; then
    warn "AWS credentials not valid. Attempting SSO login..."
    aws sso login --profile cdc-shared
fi

# Change to terraform directory
cd "$TERRAFORM_DIR"

# Initialize Terraform with backend config
log "Initializing Terraform..."
terraform init -backend-config="$BACKEND_CONFIG" -reconfigure

# Plan the infrastructure changes
log "Planning infrastructure changes..."
terraform plan -var-file="$TFVARS" -out="$ENVIRONMENT.tfplan"

# Ask for confirmation before applying
echo -e "${YELLOW}Review the plan above. Do you want to apply these changes? (yes/no)${NC}"
read -r confirmation
if [[ "$confirmation" != "yes" ]]; then
    log "Deployment cancelled by user"
    exit 0
fi

# Apply the infrastructure changes
log "Applying infrastructure changes..."
terraform apply "$ENVIRONMENT.tfplan"

# Get the S3 bucket name from Terraform output
S3_BUCKET=$(terraform output -raw s3_bucket_name)
CLOUDFRONT_ID=$(terraform output -raw cloudfront_distribution_id)

log "Infrastructure deployed successfully!"
log "S3 Bucket: $S3_BUCKET"
log "CloudFront Distribution: $CLOUDFRONT_ID"

# Sync website files to S3
log "Uploading website files to S3..."
aws s3 sync "$SRC_DIR" "s3://$S3_BUCKET" \
    --profile "$AWS_PROFILE" \
    --delete \
    --cache-control "max-age=86400" \
    --exclude "*.DS_Store"

# Set specific cache headers for different file types
log "Setting cache headers for static assets..."

# Long cache for CSS, JS, and images
aws s3 cp "$SRC_DIR" "s3://$S3_BUCKET" \
    --profile "$AWS_PROFILE" \
    --recursive \
    --exclude "*" \
    --include "*.css" \
    --include "*.js" \
    --include "*.png" \
    --include "*.jpg" \
    --include "*.jpeg" \
    --include "*.gif" \
    --include "*.svg" \
    --include "*.ico" \
    --cache-control "max-age=31536000, immutable"

# Short cache for HTML files
aws s3 cp "$SRC_DIR" "s3://$S3_BUCKET" \
    --profile "$AWS_PROFILE" \
    --recursive \
    --exclude "*" \
    --include "*.html" \
    --cache-control "max-age=3600"

log "Files uploaded successfully!"

# Invalidate CloudFront cache
log "Invalidating CloudFront cache..."
INVALIDATION_ID=$(aws cloudfront create-invalidation \
    --profile "$AWS_PROFILE" \
    --distribution-id "$CLOUDFRONT_ID" \
    --paths "/*" \
    --query 'Invalidation.Id' \
    --output text)

log "CloudFront invalidation created: $INVALIDATION_ID"

# Wait for invalidation to complete (optional)
info "Waiting for CloudFront invalidation to complete..."
aws cloudfront wait invalidation-completed \
    --profile "$AWS_PROFILE" \
    --distribution-id "$CLOUDFRONT_ID" \
    --id "$INVALIDATION_ID"

log "CloudFront invalidation completed!"

# Display final information
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}     DEPLOYMENT COMPLETED SUCCESSFULLY${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${GREEN}Website URL: https://$DOMAIN${NC}"
echo -e "${GREEN}S3 Bucket: $S3_BUCKET${NC}"
echo -e "${GREEN}CloudFront Distribution: $CLOUDFRONT_ID${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Test the website at https://$DOMAIN"
echo "2. Verify SSL certificate is working"
echo "3. Test HubSpot forms integration"
echo "4. Monitor CloudWatch logs for any issues"
echo ""

# Clean up
rm -f "$ENVIRONMENT.tfplan"

log "Deployment script completed!"