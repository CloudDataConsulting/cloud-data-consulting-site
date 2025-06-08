#!/bin/bash

# Webflow API Test Script
# Run this after upgrading to CMS plan to test API connection

# Set your credentials (get these from Webflow Settings > Integrations)
export WEBFLOW_API_TOKEN="your_token_here"
export WEBFLOW_SITE_ID="your_site_id_here"

echo "Testing Webflow API connection..."

# Test 1: Get site info
echo "1. Getting site information:"
curl -X GET "https://api.webflow.com/sites/$WEBFLOW_SITE_ID" \
  -H "Authorization: Bearer $WEBFLOW_API_TOKEN" \
  -H "accept-version: 1.0.0" \
  -w "\n\nStatus Code: %{http_code}\n"

echo -e "\n" 

# Test 2: List collections (CMS)
echo "2. Getting CMS collections:"
curl -X GET "https://api.webflow.com/sites/$WEBFLOW_SITE_ID/collections" \
  -H "Authorization: Bearer $WEBFLOW_API_TOKEN" \
  -H "accept-version: 1.0.0" \
  -w "\n\nStatus Code: %{http_code}\n"

echo -e "\n"

# Test 3: Get domains
echo "3. Getting site domains:"
curl -X GET "https://api.webflow.com/sites/$WEBFLOW_SITE_ID/domains" \
  -H "Authorization: Bearer $WEBFLOW_API_TOKEN" \
  -H "accept-version: 1.0.0" \
  -w "\n\nStatus Code: %{http_code}\n"

echo -e "\nIf you see JSON responses with 200 status codes, your API is working!"