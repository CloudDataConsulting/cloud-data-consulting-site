export ANTHROPIC_API_KEY=$(op item get "API-Cred-Anthropic-$AI_ENGINEER" --fields credential --reveal)
export OPENAI_API_KEY=$(op item get "API-Cred-openai-$AI_ENGINEER" --fields credential --reveal)
export YOUTUBE_API_KEY=$(op item get "API-Cred-Google-Youtube-data-$AI_ENGINEER" --fields credential --reveal)
export GEMINI_API_KEY=$(op item get "API-Cred-google-aistudio-$AI_ENGINEER" --fields credential --reveal)
export GOOGLE_API_KEY=$(op item get "API-Cred-google-aistudio-$AI_ENGINEER" --fields credential --reveal)


# Optional: Add other API keys for future integrations
# HUBSPOT_API_KEY=your_hubspot_key
# OPENAI_API_KEY=your_openai_key