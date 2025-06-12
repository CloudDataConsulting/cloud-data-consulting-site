#!/bin/bash

# Website Testing Script for Cloud Data Consulting
# Tests all internal links and provides quick feedback

echo "🚀 Cloud Data Consulting - Website Link Test"
echo "=============================================="

# Check if Node.js is available
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is required but not installed."
    echo "   Please install Node.js from https://nodejs.org/"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "test-links-simple.js" ]; then
    echo "❌ Please run this script from the project root directory"
    echo "   (where test-links-simple.js is located)"
    exit 1
fi

# Run the link test
echo "🔍 Testing all website links..."
echo ""

if node test-links-simple.js; then
    echo ""
    echo "✅ SUCCESS: All website links are working correctly!"
    echo "🌐 Your website is ready for deployment."
    exit 0
else
    echo ""
    echo "❌ FAILED: Some links are broken."
    echo "📝 Please fix the broken links listed above and run the test again."
    echo ""
    echo "💡 Quick fixes:"
    echo "   - Check file paths in HTML files"
    echo "   - Ensure all referenced files exist"
    echo "   - Verify case sensitivity in filenames"
    echo ""
    echo "🔧 Run with verbose output for more details:"
    echo "   node test-links-simple.js --verbose"
    exit 1
fi