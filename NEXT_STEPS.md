# Rapid Site Development Plan

## Webflow API Setup (After CMS Upgrade)

1. **Get API credentials**: Settings → Integrations → Generate API Token
2. **Set up environment**:
```bash
# Copy template and add your credentials
cp .env.template .env
# Edit .env with your actual API token and site ID
```

3. **Test API connection**:
```bash
source .env
./scripts/webflow-api-test.sh
```

4. **Ready to publish content**:
```bash
./scripts/publish-content.sh
```

## Priority Content (Based on ICP Analysis)

### Homepage Hero (Replace Immediately)
**Current**: "We build Snowflake data warehouses"
**New**: "Your AI Strategy Starts With Your Data Strategy — Build a Modern Data Stack that Delivers Business Value Fast"

### Quick-Win Services (Easy to Sell)
1. **Snowflake Cost Audit** - Low entry, high ROI
2. **AI Readiness Assessment** - Taps into AI hype
3. **Data Stack Assessment** - Hook for long-term work

### Lead Magnet
"AI Readiness Assessment" - Interactive quiz or PDF download

## Content Generation Workflow

1. Use prompts in `/prompts/` with Claude
2. Save generated content to `/content/`
3. Push to Webflow via API or manual paste
4. Test and iterate

## Marketing Message Framework
"AI is the buzz — but bad data is the bottleneck. We help fast-growing companies get their data house in order so they can actually use AI."