#!/bin/bash

# Quick script to find your Webflow Site ID

echo "Option 1: Check your published site's HTML source"
echo "Go to your live site and view page source. Look for:"
echo '  <html data-wf-site="YOUR_SITE_ID_HERE">'
echo ""
echo "Option 2: Use your Site Token to list sites"
echo "If you have a Site Token (not OAuth), try this:"
echo ""

# Assuming you have your Site Token in 1Password
SITE_TOKEN=$(op item get "API-Cred-Webflow-$AI_ENGINEER" --fields credential --reveal 2>/dev/null)

if [ -n "$SITE_TOKEN" ]; then
    echo "Testing with your Site Token..."
    curl -X GET "https://api.webflow.com/v2/sites" \
      -H "Authorization: Bearer $SITE_TOKEN" \
      -H "accept: application/json" | jq '.'
else
    echo "No Site Token found in 1Password."
    echo "Update this script with your token directly:"
    echo 'SITE_TOKEN="your_site_token_here"'
fi