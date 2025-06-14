#!/bin/bash

# Website Project Environment Configuration
# Minimal project-specific configuration that sources shared CDC config

# =============================================================================
# PROJECT CONFIGURATION
# =============================================================================

export PROJECT_NAME="cloud-data-consulting-site"
export ENVIRONMENT="${ENVIRONMENT:-prd}"
export REQUIRED_TOOLS=("aws" "node" "npm" "op")

# =============================================================================
# AWS CONFIGURATION
# =============================================================================

export AWS_PROFILE="cdc-website"
export TF_VAR_aws_target_profile=$AWS_PROFILE
export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"

# =============================================================================
# PROJECT-SPECIFIC ENVIRONMENT VARIABLES
# =============================================================================

# Website deployment settings
export WEBSITE_DOMAIN="clouddataconsulting.io"
export WEBSITE_BUCKET="s3://clouddataconsulting.io"
export CLOUDFRONT_DISTRIBUTION_ID=""  # Set after first deployment

# Build settings
export NODE_ENV="${ENVIRONMENT}"
export BUILD_DIR="dist"

# =============================================================================
# SHARED CONFIGURATION LOADING
# =============================================================================

export CDC_SHARED_CONFIG_PATH="${CDC_SHARED_CONFIG_PATH:-./shared}"

if [ -f "${CDC_SHARED_CONFIG_PATH}/scripts/env-base.sh" ]; then
    source "${CDC_SHARED_CONFIG_PATH}/scripts/env-base.sh"
else
    echo "❌ CDC shared config not found. Run: git submodule update --init --recursive"
    exit 1
fi

# =============================================================================
# CREDENTIAL LOADING
# =============================================================================

# Use project-specific AWS service account for deployments
load_aws_service_account "$PROJECT_NAME" "$ENVIRONMENT"

# Load development API keys for AI features (optional)
load_dev_api_keys

# =============================================================================
# PROJECT-SPECIFIC FUNCTIONS
# =============================================================================

# Function to build the website
build_website() {
    info "🔨 Building website..."
    # Note: This is a vanilla HTML/CSS/JS project without npm build
    # Copy src/ contents to BUILD_DIR for deployment
    if [ -d "src" ]; then
        mkdir -p "$BUILD_DIR"
        cp -r src/* "$BUILD_DIR/"
        success "Website build completed"
        info "   Build directory: $BUILD_DIR"
    else
        error "Source directory 'src' not found"
        return 1
    fi
}

# Function to deploy to S3
deploy_to_s3() {
    if [ ! -d "$BUILD_DIR" ]; then
        error "Build directory not found. Run build_website first."
        return 1
    fi
    
    info "🚀 Deploying to S3..."
    aws s3 sync "$BUILD_DIR/" "$WEBSITE_BUCKET" --delete
    
    if [ $? -eq 0 ]; then
        success "Deployment to S3 completed"
    else
        error "S3 deployment failed"
        return 1
    fi
}

# Function to invalidate CloudFront cache
invalidate_cloudfront() {
    if [ -z "$CLOUDFRONT_DISTRIBUTION_ID" ]; then
        warning "CLOUDFRONT_DISTRIBUTION_ID not set. Skipping invalidation."
        return 0
    fi
    
    info "🔄 Invalidating CloudFront cache..."
    aws cloudfront create-invalidation \
        --distribution-id "$CLOUDFRONT_DISTRIBUTION_ID" \
        --paths "/*"
    
    if [ $? -eq 0 ]; then
        success "CloudFront invalidation started"
    else
        error "CloudFront invalidation failed"
        return 1
    fi
}

# Function to do full deployment
deploy_website() {
    build_website && \
    deploy_to_s3 && \
    invalidate_cloudfront
    
    if [ $? -eq 0 ]; then
        success "🎉 Website deployment completed!"
        info "   Visit: https://$WEBSITE_DOMAIN"
    else
        error "Website deployment failed"
        return 1
    fi
}