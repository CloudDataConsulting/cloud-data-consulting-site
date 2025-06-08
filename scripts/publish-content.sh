#!/bin/bash

# Webflow Content Publishing Script
# Publishes blog posts and other CMS content via API

# Source environment variables
source ./env.sh

if [ -z "$WEBFLOW_API_TOKEN" ] || [ -z "$WEBFLOW_SITE_ID" ]; then
    echo "Error: WEBFLOW_API_TOKEN or WEBFLOW_SITE_ID not set"
    echo "Check your env.sh file and 1Password credentials"
    exit 1
fi

# Function to create a blog post
create_blog_post() {
    local title="$1"
    local slug="$2"
    local content="$3"
    local collection_id="$4"
    
    echo "Publishing: $title"
    
    curl -X POST "https://api.webflow.com/sites/$WEBFLOW_SITE_ID/collections/$collection_id/items" \
      -H "Authorization: Bearer $WEBFLOW_API_TOKEN" \
      -H "accept-version: 1.0.0" \
      -H "Content-Type: application/json" \
      -d "{
        \"fields\": {
          \"name\": \"$title\",
          \"slug\": \"$slug\",
          \"published\": true,
          \"post-body\": \"$content\"
        }
      }"
}

# Example usage (uncomment when ready):
# create_blog_post "Why Your AI Project Will Fail Without a Modern Data Stack" "ai-project-failure-data-stack" "<p>Your blog content here...</p>" "your_blog_collection_id"

echo "Content publishing script ready. Update with your collection IDs and content."