# Website Link Testing

This repository includes comprehensive link testing tools to ensure all website navigation works correctly.

## Quick Start

Test all internal links:
```bash
node test-links-simple.js
```

Test with detailed output:
```bash
node test-links-simple.js --verbose
```

## Available Testing Commands

### NPM Scripts

```bash
# Quick link check (recommended)
npm test

# Verbose output with all details
npm run test:verbose

# Deep crawl (3 levels) with verbose output
npm run test:deep

# Quick test (only direct links from homepage)
npm run test:quick

# Complete verification
npm run check
```

### Direct Node.js Commands

```bash
# Basic test
node test-links-simple.js

# Test with verbose output
node test-links-simple.js --verbose

# Limit crawl depth
node test-links-simple.js --depth=1

# Advanced testing (requires jsdom dependency)
node test-links.js --verbose --external
```

## What Gets Tested

### ✅ Internal Links Tested
- ✅ All HTML page links (`href` attributes)
- ✅ Image sources (`src` attributes) 
- ✅ CSS and JavaScript file references
- ✅ Relative path resolution
- ✅ Directory index.html resolution
- ✅ File extension auto-completion (.html)

### ⏭️ Links Skipped
- ⏭️ External URLs (http/https)
- ⏭️ Email links (mailto:)
- ⏭️ Phone links (tel:)
- ⏭️ Anchor-only links (#section)
- ⏭️ Data URLs (data:)

## Testing Tools

### Simple Tester (`test-links-simple.js`)
- **Dependencies:** None (uses only Node.js built-ins)
- **Speed:** Fast
- **Coverage:** Internal links only
- **Best for:** Daily development, CI/CD

### Advanced Tester (`test-links.js`)
- **Dependencies:** jsdom
- **Speed:** Slower but more thorough
- **Coverage:** Internal + external links (optional)
- **Best for:** Comprehensive testing, pre-deployment

## Example Output

```
🚀 Starting website link test...
Local path: /Users/user/project/src
Max depth: 2

🔍 Crawling: index.html (depth: 0)
🔍   Found 15 links
✅ ✓ ai-readiness-assessment.html → ai-readiness-assessment.html
✅ ✓ ai-ready-platform.html → ai-ready-platform.html
✅ ✓ data-modernization.html → data-modernization.html
✅ ✓ strategic-enablement.html → strategic-enablement.html
⚠️ ⏭ Skipping external: https://fonts.googleapis.com/css2

============================================================
📊 LINK TEST RESULTS
============================================================
⏱️  Duration: 0.05s
📄 Files crawled: 5
🔗 Total links found: 23
✅ Working links: 18
❌ Broken links: 0
⏭️  Skipped links: 5
============================================================
🎉 All internal links are working!

📄 HTML Files Discovered: index.html, ai-readiness-assessment.html, ai-ready-platform.html, data-modernization.html, strategic-enablement.html
```

## Integration with Development Workflow

### Pre-commit Hook
Add to your git pre-commit hook:
```bash
#!/bin/sh
npm test || exit 1
```

### CI/CD Pipeline
Add to your GitHub Actions or similar:
```yaml
- name: Test website links
  run: npm test
```

### Local Development
Run before making commits:
```bash
npm run check
```

## Troubleshooting

### Common Issues

**"File not found" errors:**
- Check file paths in HTML
- Ensure file extensions match
- Verify case sensitivity

**"Cannot read file" errors:**
- Check file permissions
- Verify `src/` directory structure
- Ensure files are UTF-8 encoded

### Adding New Pages

When you add new HTML files:
1. Link them from existing pages
2. Run `npm test` to verify links
3. Add internal navigation as needed

### Custom Configuration

Modify the tester options in the script files:
- `maxDepth`: How deep to crawl (default: 2)
- `localPath`: Directory containing HTML files
- `verbose`: Show detailed output

## File Structure Expected

```
src/
├── index.html                    # Homepage
├── ai-readiness-assessment.html  # Service page
├── ai-ready-platform.html       # Service page  
├── data-modernization.html      # Service page
├── strategic-enablement.html    # Service page
└── assets/
    ├── images/
    │   └── logos/
    └── css/
```

This testing framework ensures all your website links work correctly and helps catch broken navigation before deployment.