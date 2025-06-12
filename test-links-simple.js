#!/usr/bin/env node

/**
 * Simple Website Link Tester (No External Dependencies)
 * Tests all links on the Cloud Data Consulting website using only Node.js built-ins
 * 
 * Usage:
 *   node test-links-simple.js [options]
 * 
 * Options:
 *   --verbose     Show detailed output
 *   --depth=N     Maximum crawl depth (default: 2)
 */

const fs = require('fs');
const path = require('path');

class SimpleLinkTester {
    constructor(options = {}) {
        this.visited = new Set();
        this.broken = [];
        this.working = [];
        this.skipped = [];
        
        this.options = {
            verbose: options.verbose || false,
            maxDepth: options.depth || 2,
            localPath: path.join(__dirname, 'src')
        };
        
        this.startTime = Date.now();
    }

    log(message, level = 'info') {
        const prefix = {
            'info': '🔍',
            'success': '✅',
            'error': '❌',
            'warning': '⚠️'
        }[level] || 'ℹ️';
        
        if (this.options.verbose || level === 'error' || level === 'info') {
            console.log(`${prefix} ${message}`);
        }
    }

    extractLinks(html) {
        const links = new Set();
        
        // Simple regex to find href attributes
        const hrefRegex = /href\s*=\s*["']([^"']+)["']/gi;
        let match;
        
        while ((match = hrefRegex.exec(html)) !== null) {
            const href = match[1];
            if (href && !href.startsWith('mailto:') && !href.startsWith('tel:') && !href.startsWith('#')) {
                links.add(href);
            }
        }
        
        // Find src attributes for scripts and images
        const srcRegex = /src\s*=\s*["']([^"']+)["']/gi;
        while ((match = srcRegex.exec(html)) !== null) {
            const src = match[1];
            if (src && !src.startsWith('data:') && !src.startsWith('http') && !src.startsWith('//')) {
                links.add(src);
            }
        }
        
        return Array.from(links);
    }

    isExternalLink(url) {
        return url.startsWith('http://') || url.startsWith('https://') || url.startsWith('//');
    }

    normalizeLocalPath(url) {
        // Remove leading slashes and fragments
        let cleanUrl = url.replace(/^\/+/, '').split('#')[0];
        
        // Handle empty or root path
        if (!cleanUrl || cleanUrl === '/') {
            return 'index.html';
        }
        
        // Handle directory paths
        if (cleanUrl.endsWith('/')) {
            return cleanUrl + 'index.html';
        }
        
        // Add .html extension if no extension present
        if (!path.extname(cleanUrl)) {
            return cleanUrl + '.html';
        }
        
        return cleanUrl;
    }

    testLocalFile(relativePath) {
        try {
            const fullPath = path.join(this.options.localPath, relativePath);
            return fs.existsSync(fullPath);
        } catch (error) {
            return false;
        }
    }

    async testLink(url, sourceFile) {
        // Skip external links
        if (this.isExternalLink(url)) {
            this.skipped.push({ url, source: sourceFile, reason: 'External link' });
            this.log(`⏭ Skipping external: ${url}`, 'warning');
            return { status: 'skipped', type: 'external' };
        }
        
        const localPath = this.normalizeLocalPath(url);
        const exists = this.testLocalFile(localPath);
        
        if (exists) {
            this.working.push({ url, localPath, source: sourceFile });
            this.log(`✓ ${url} → ${localPath}`, 'success');
            return { status: 'success', localPath };
        } else {
            this.broken.push({ url, localPath, source: sourceFile, error: 'File not found' });
            this.log(`✗ ${url} → ${localPath} (NOT FOUND)`, 'error');
            return { status: 'error', localPath };
        }
    }

    async crawlFile(relativePath, depth = 0) {
        if (depth > this.options.maxDepth || this.visited.has(relativePath)) {
            return;
        }
        
        this.visited.add(relativePath);
        this.log(`Crawling: ${relativePath} (depth: ${depth})`, 'info');
        
        try {
            const fullPath = path.join(this.options.localPath, relativePath);
            
            if (!fs.existsSync(fullPath)) {
                this.log(`File not found: ${fullPath}`, 'error');
                return;
            }
            
            const html = fs.readFileSync(fullPath, 'utf8');
            const links = this.extractLinks(html);
            
            this.log(`  Found ${links.length} links`, 'info');
            
            // Test each link
            for (const link of links) {
                const result = await this.testLink(link, relativePath);
                
                // Recursively crawl internal HTML files
                if (result.status === 'success' && 
                    result.localPath.endsWith('.html') &&
                    depth < this.options.maxDepth) {
                    await this.crawlFile(result.localPath, depth + 1);
                }
            }
            
        } catch (error) {
            this.log(`Error reading ${relativePath}: ${error.message}`, 'error');
        }
    }

    async run() {
        this.log('🚀 Starting website link test...', 'info');
        this.log(`Local path: ${this.options.localPath}`, 'info');
        this.log(`Max depth: ${this.options.maxDepth}`, 'info');
        this.log('', 'info');
        
        await this.crawlFile('index.html');
        
        return this.printResults();
    }

    printResults() {
        const duration = ((Date.now() - this.startTime) / 1000).toFixed(2);
        const total = this.working.length + this.broken.length + this.skipped.length;
        
        console.log('\n' + '='.repeat(60));
        console.log('📊 LINK TEST RESULTS');
        console.log('='.repeat(60));
        console.log(`⏱️  Duration: ${duration}s`);
        console.log(`📄 Files crawled: ${this.visited.size}`);
        console.log(`🔗 Total links found: ${total}`);
        console.log(`✅ Working links: ${this.working.length}`);
        console.log(`❌ Broken links: ${this.broken.length}`);
        console.log(`⏭️  Skipped links: ${this.skipped.length}`);
        
        if (this.broken.length > 0) {
            console.log('\n❌ BROKEN LINKS:');
            console.log('-'.repeat(40));
            this.broken.forEach(item => {
                console.log(`🔗 ${item.url}`);
                console.log(`   Source: ${item.source}`);
                console.log(`   Expected: ${item.localPath}`);
                console.log(`   Error: ${item.error}`);
                console.log('');
            });
        }
        
        if (this.skipped.length > 0 && this.options.verbose) {
            console.log('\n⏭️  SKIPPED LINKS:');
            console.log('-'.repeat(40));
            this.skipped.forEach(item => {
                console.log(`   ${item.url} (${item.reason})`);
            });
            console.log('');
        }
        
        console.log('='.repeat(60));
        
        const success = this.broken.length === 0;
        console.log(success ? '🎉 All internal links are working!' : '⚠️  Some internal links are broken');
        
        // List all HTML files found
        const htmlFiles = Array.from(this.visited);
        console.log(`\n📄 HTML Files Discovered: ${htmlFiles.join(', ')}`);
        
        return success;
    }
}

// CLI Interface
function parseArgs() {
    const args = process.argv.slice(2);
    const options = {
        verbose: false,
        depth: 2
    };
    
    for (const arg of args) {
        if (arg.startsWith('--depth=')) {
            options.depth = parseInt(arg.split('=')[1]) || 2;
        } else if (arg === '--verbose') {
            options.verbose = true;
        } else if (arg === '--help' || arg === '-h') {
            console.log(`
Simple Website Link Tester

Usage: node test-links-simple.js [options]

Options:
  --depth=N     Maximum crawl depth (default: 2)
  --verbose     Show detailed output including skipped links
  --help, -h    Show this help

Examples:
  node test-links-simple.js                    # Test all internal links
  node test-links-simple.js --verbose          # Show detailed output
  node test-links-simple.js --depth=1          # Test only direct links
            `);
            process.exit(0);
        }
    }
    
    return options;
}

// Main execution
if (require.main === module) {
    const options = parseArgs();
    const tester = new SimpleLinkTester(options);
    
    tester.run().then(success => {
        process.exit(success ? 0 : 1);
    }).catch(error => {
        console.error('❌ Fatal error:', error.message);
        process.exit(1);
    });
}

module.exports = SimpleLinkTester;