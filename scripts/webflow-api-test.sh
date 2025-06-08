#!/bin/bash

# Webflow API Test Script
# Run this after upgrading to CMS plan to test API connection

# Environment variables should already be loaded

echo "Testing Webflow API connection..."

# Test 1: Get site info
echo "1. Getting site information:"
curl -X GET "https://api.webflow.com/v2/sites/$WEBFLOW_SITE_ID" \
  -H "Authorization: Bearer $WEBFLOW_API_TOKEN" \
  -H "accept: application/json" \
  -w "\n\nStatus Code: %{http_code}\n"

echo -e "\n" 

# Test 2: List collections (CMS)
echo "2. Getting CMS collections:"
curl -X GET "https://api.webflow.com/v2/collections?site_id=$WEBFLOW_SITE_ID" \
  -H "Authorization: Bearer $WEBFLOW_API_TOKEN" \
  -H "accept: application/json" \
  -w "\n\nStatus Code: %{http_code}\n"

echo -e "\n"

# Test 3: Get domains
echo "3. Getting site domains:"
curl -X GET "https://api.webflow.com/v2/sites/$WEBFLOW_SITE_ID" \
  -H "Authorization: Bearer $WEBFLOW_API_TOKEN" \
  -H "accept: application/json" \
  -w "\n\nStatus Code: %{http_code}\n"

echo -e "\nIf you see JSON responses with 200 status codes, your API is working!"