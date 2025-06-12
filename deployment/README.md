# Cloud Data Consulting Website Deployment

This directory contains the deployment infrastructure and scripts for the Cloud Data Consulting website.

## Architecture

- **Static Website**: S3 bucket with website hosting
- **CDN**: CloudFront distribution for global delivery and SSL
- **DNS**: Route53 for domain management
- **SSL**: ACM certificate with automatic renewal
- **Infrastructure**: Managed with Terraform
- **State Management**: Terraform state stored in cdc-terraform account

## Prerequisites

1. **AWS CLI** configured with SSO profiles
2. **Terraform** >= 1.0
3. **Permissions** for cdc-prd and cdc-terraform accounts

## Deployment Environments

### Staging
- **Domain**: clouddataconsulting.io
- **Purpose**: Testing and validation
- **Deploy Command**: `./deployment/deploy.sh staging`

### Production
- **Domain**: clouddataconsulting.com
- **Purpose**: Live website
- **Deploy Command**: `./deployment/deploy.sh production`

## Quick Start

1. **Initial Setup** (one-time):
   ```bash
   # Ensure AWS SSO is configured
   aws sso login --profile cdc-shared
   
   # Verify Terraform state bucket exists in cdc-terraform account
   # (This should already be set up)
   ```

2. **Deploy to Staging**:
   ```bash
   ./deployment/deploy.sh staging
   ```

3. **Deploy to Production**:
   ```bash
   ./deployment/deploy.sh production
   ```

## Deployment Process

The deployment script (`deploy.sh`) performs these steps:

1. **Validation**: Checks environment, tools, and source files
2. **AWS Authentication**: Verifies/refreshes SSO credentials
3. **Infrastructure**: Terraform plan and apply
4. **File Upload**: Sync website files to S3
5. **Cache Headers**: Set appropriate caching policies
6. **CDN Invalidation**: Clear CloudFront cache
7. **Verification**: Display deployment results

## File Structure

```
deployment/
├── README.md                 # This file
└── deploy.sh                 # Main deployment script

terraform/
├── main.tf                   # Infrastructure definition
├── variables.tf              # Variable definitions
├── outputs.tf                # Output values
├── staging.tfvars           # Staging environment variables
├── production.tfvars        # Production environment variables
├── backend-staging.hcl      # Staging backend configuration
└── backend-production.hcl   # Production backend configuration
```

## Manual Terraform Commands

If you need to run Terraform manually:

```bash
cd terraform

# Initialize for staging
terraform init -backend-config=backend-staging.hcl

# Plan for staging
terraform plan -var-file=staging.tfvars

# Apply for staging
terraform apply -var-file=staging.tfvars
```

## AWS Accounts Used

- **cdc-prd**: Website hosting resources (S3, CloudFront, Route53)
- **cdc-terraform**: Terraform state storage and locking
- **cdc-shared**: SSO authentication

## Troubleshooting

### AWS SSO Issues
```bash
# Refresh SSO credentials
aws sso login --profile cdc-shared

# Check current identity
aws sts get-caller-identity --profile cdc-prd
```

### Terraform State Issues
```bash
# List Terraform workspaces
terraform workspace list

# Show current state
terraform show
```

### S3 Upload Issues
```bash
# Manual sync to S3
aws s3 sync src/ s3://BUCKET_NAME --profile cdc-prd

# Check bucket policy
aws s3api get-bucket-policy --bucket BUCKET_NAME --profile cdc-prd
```

### CloudFront Issues
```bash
# List distributions
aws cloudfront list-distributions --profile cdc-prd

# Create manual invalidation
aws cloudfront create-invalidation \
  --distribution-id DISTRIBUTION_ID \
  --paths "/*" \
  --profile cdc-prd
```

## Security Notes

- SSL certificates are automatically provisioned and renewed
- S3 bucket is configured with CloudFront Origin Access Control (OAC)
- All traffic is redirected to HTTPS
- Terraform state is encrypted and locked

## Cost Optimization

- CloudFront uses PriceClass_100 (US, Canada, Europe)
- S3 lifecycle policies can be added for log cleanup
- Monitoring can be enabled for cost tracking

## Monitoring

After deployment, monitor:
- Website availability at https://domain.com
- SSL certificate expiration (auto-renewed)
- CloudFront cache hit rates
- S3 storage usage and costs

## Support

For issues with:
- **Infrastructure**: Check Terraform outputs and AWS console
- **DNS**: Verify Route53 records and domain configuration
- **SSL**: Check ACM certificate status
- **Performance**: Review CloudFront metrics