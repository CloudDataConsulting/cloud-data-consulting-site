#!/bin/bash

# Get Webflow Access Token using Client Credentials
# This script generates an access token using your app's Client ID and Secret

source ./env.sh

# Webflow OAuth endpoint
TOKEN_URL="https://api.webflow.com/oauth/access_token"

# Your app credentials (you'll need to set these)
CLIENT_ID="your_client_id_here"
CLIENT_SECRET="your_client_secret_here"

echo "Generating access token..."

# Make the OAuth request
response=$(curl -s -X POST "$TOKEN_URL" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET")

echo "Response:"
echo "$response" | jq '.'

# Extract the access token
access_token=$(echo "$response" | jq -r '.access_token')

if [ "$access_token" != "null" ] && [ -n "$access_token" ]; then
    echo -e "\nSuccess! Your access token is:"
    echo "$access_token"
    echo -e "\nAdd this to your 1Password as 'API-Cred-Webflow-$AI_ENGINEER'"
else
    echo -e "\nError: Could not generate access token"
fi