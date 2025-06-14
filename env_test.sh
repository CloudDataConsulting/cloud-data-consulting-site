#!/bin/bash

# Test Environment Configuration
# Copy this template to your project as env_test.sh for testing configurations

# =============================================================================
# TEST ENVIRONMENT SETUP
# =============================================================================

# Override environment for testing
export ENVIRONMENT="test"
export PROJECT_NAME="cloud-data-consulting-site-test"

# Test-specific AWS profile (if different)
export AWS_PROFILE="cdc-website-test"

# =============================================================================
# LOAD MAIN ENVIRONMENT WITH TEST OVERRIDES
# =============================================================================

# Source the main environment configuration
if [ -f "./env.sh" ]; then
    source "./env.sh"
else
    echo "❌ Main env.sh not found"
    exit 1
fi

# =============================================================================
# TEST-SPECIFIC OVERRIDES
# =============================================================================

# Override credentials for test environment
# Test website domain and bucket
export WEBSITE_DOMAIN="test.clouddataconsulting.io"
export WEBSITE_BUCKET="s3://test.clouddataconsulting.io"

# Test-specific environment variables
export TF_VAR_environment="test"
export NODE_ENV="test"

# =============================================================================
# TEST HELPER FUNCTIONS
# =============================================================================

# Function to run connectivity tests
run_connectivity_tests() {
    info "🧪 Running connectivity tests..."
    
    local test_count=0
    local pass_count=0
    
    # Test AWS connectivity
    ((test_count++))
    if aws sts get-caller-identity >/dev/null 2>&1; then
        success "✓ AWS connectivity"
        ((pass_count++))
    else
        error "✗ AWS connectivity"
    fi
    
    # Test 1Password connectivity
    ((test_count++))
    if op account list >/dev/null 2>&1; then
        success "✓ 1Password connectivity"
        ((pass_count++))
    else
        error "✗ 1Password connectivity"
    fi
    
    # Test website build functionality
    ((test_count++))
    if [ -d "src" ]; then
        success "✓ Source directory available"
        ((pass_count++))
    else
        error "✗ Source directory missing"
    fi
    
    echo ""
    if [ $pass_count -eq $test_count ]; then
        success "🎉 All connectivity tests passed ($pass_count/$test_count)"
        return 0
    else
        error "❌ Some tests failed ($pass_count/$test_count)"
        return 1
    fi
}

# Function to validate test environment configuration
validate_test_config() {
    info "🔍 Validating test configuration..."
    
    local issues=()
    
    # Check required environment variables
    [ -z "$PROJECT_NAME" ] && issues+=("PROJECT_NAME not set")
    [ -z "$ENVIRONMENT" ] && issues+=("ENVIRONMENT not set")
    [ -z "$AWS_PROFILE" ] && issues+=("AWS_PROFILE not set")
    
    # Check if test environment is properly isolated
    if [[ "$PROJECT_NAME" != *"test"* ]] && [[ "$ENVIRONMENT" != "test" ]]; then
        issues+=("Project not configured for testing (missing 'test' in name or environment)")
    fi
    
    # Website-specific validations
    [ -z "$WEBSITE_DOMAIN" ] && issues+=("WEBSITE_DOMAIN not set")
    [ -z "$WEBSITE_BUCKET" ] && issues+=("WEBSITE_BUCKET not set")
    
    if [ ${#issues[@]} -eq 0 ]; then
        success "✓ Test configuration valid"
        return 0
    else
        error "❌ Configuration issues found:"
        for issue in "${issues[@]}"; do
            echo "   - $issue"
        done
        return 1
    fi
}

# Function to show test environment status
test_status() {
    echo ""
    info "🧪 Test Environment Status:"
    echo "   Project: $PROJECT_NAME"
    echo "   Environment: $ENVIRONMENT"
    aws_auth_status
    echo "   Website Domain: $WEBSITE_DOMAIN"
    echo "   Website Bucket: $WEBSITE_BUCKET"
    dev_tools_status
}

# =============================================================================
# STARTUP SUMMARY
# =============================================================================

echo ""
success "🧪 Test environment configured for: $PROJECT_NAME"
echo ""
info "Available test commands:"
echo "   run_connectivity_tests   - Test all external connections"
echo "   validate_test_config     - Validate test configuration"
echo "   test_status             - Show test environment status"
echo ""

# Auto-run validation
validate_test_config