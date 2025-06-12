#!/usr/bin/env node

/**
 * Website Link Crawler and Tester
 * Tests all links on the Cloud Data Consulting website
 * 
 * Usage:
 *   node test-links.js [starting-url] [options]
 * 
 * Options:
 *   --depth=N     Maximum crawl depth (default: 3)
 *   --verbose     Show detailed output
 *   --external    Test external links too
 *   --timeout=N   Request timeout in ms (default: 5000)
 */

const fs = require('fs');
const path = require('path');
const { JSDOM } = require('jsdom');

class LinkTester {
    constructor(options = {}) {
        this.visited = new Set();
        this.broken = new Set();
        this.external = new Set();
        this.results = {
            total: 0,
            working: 0,
            broken: 0,
            external: 0,
            skipped: 0
        };
        
        this.options = {
            maxDepth: options.depth || 3,
            verbose: options.verbose || false,
            testExternal: options.external || false,
            timeout: options.timeout || 5000,
            baseUrl: options.baseUrl || 'http://localhost:3000',
            localPath: options.localPath || path.join(__dirname, 'src')
        };
        
        this.startTime = Date.now();
    }

    log(message, level = 'info') {
        const timestamp = new Date().toISOString().split('T')[1].split('.')[0];
        const prefix = {
            'info': '🔍',
            'success': '✅',
            'error': '❌',
            'warning': '⚠️',
            'debug': '🐛'
        }[level] || 'ℹ️';
        
        if (level !== 'debug' || this.options.verbose) {
            console.log(`${prefix} [${timestamp}] ${message}`);
        }
    }

    async testLocalFile(filePath) {
        try {
            const fullPath = path.resolve(this.options.localPath, filePath);
            const exists = fs.existsSync(fullPath);
            
            if (!exists) {
                // Try with .html extension
                const htmlPath = fullPath.endsWith('.html') ? fullPath : fullPath + '.html';
                return fs.existsSync(htmlPath);
            }
            
            return exists;
        } catch (error) {
            this.log(`Error checking local file ${filePath}: ${error.message}`, 'error');
            return false;
        }
    }

    async testExternalUrl(url) {
        if (!this.options.testExternal) {
            this.results.external++;
            return { status: 'skipped', message: 'External link testing disabled' };
        }

        try {
            // Simple check for common external domains
            const response = await fetch(url, {
                method: 'HEAD',
                timeout: this.options.timeout,
                headers: {
                    'User-Agent': 'Mozilla/5.0 (compatible; LinkTester/1.0)'
                }
            });
            
            return {
                status: response.ok ? 'success' : 'error',
                code: response.status,
                message: response.statusText
            };
        } catch (error) {
            return {
                status: 'error',
                message: error.message
            };
        }
    }

    extractLinks(html, baseUrl) {
        const dom = new JSDOM(html);
        const document = dom.window.document;
        const links = new Set();
        
        // Get all anchor tags with href
        const anchorTags = document.querySelectorAll('a[href]');
        anchorTags.forEach(link => {
            const href = link.getAttribute('href');
            if (href) {
                links.add(href);
            }
        });
        
        // Get all form actions
        const forms = document.querySelectorAll('form[action]');
        forms.forEach(form => {
            const action = form.getAttribute('action');
            if (action) {
                links.add(action);
            }
        });
        
        // Get all script src and link href (CSS, etc.)
        const resources = document.querySelectorAll('script[src], link[href]');
        resources.forEach(resource => {
            const src = resource.getAttribute('src') || resource.getAttribute('href');
            if (src && !src.startsWith('data:') && !src.startsWith('//')) {
                links.add(src);
            }
        });
        
        return Array.from(links);
    }

    normalizeUrl(url, baseUrl) {
        // Handle various URL formats
        if (url.startsWith('http://') || url.startsWith('https://')) {
            return url; // Absolute URL
        }
        
        if (url.startsWith('//')) {
            return 'https:' + url; // Protocol-relative
        }
        
        if (url.startsWith('mailto:') || url.startsWith('tel:')) {
            return null; // Skip these
        }
        
        if (url.startsWith('#')) {
            return baseUrl + url; // Anchor link
        }
        
        // Relative URL
        if (url.startsWith('/')) {
            const base = new URL(baseUrl);
            return base.origin + url;
        }
        
        // Relative to current path
        return new URL(url, baseUrl).href;
    }

    isInternalLink(url, baseUrl) {
        try {
            const urlObj = new URL(url);
            const baseObj = new URL(baseUrl);
            return urlObj.hostname === baseObj.hostname || urlObj.hostname === 'localhost';
        } catch {
            return true; // Assume internal if parsing fails
        }
    }

    getLocalFilePath(url, baseUrl) {
        try {
            const urlObj = new URL(url);
            let pathname = urlObj.pathname;
            
            // Remove leading slash and convert to local path
            pathname = pathname.replace(/^\/+/, '');
            
            // Handle root path
            if (!pathname || pathname === '/') {
                return 'index.html';
            }
            
            // Handle directory paths
            if (pathname.endsWith('/')) {
                return pathname + 'index.html';
            }
            
            // Add .html if no extension
            if (!path.extname(pathname)) {
                return pathname + '.html';
            }
            
            return pathname;
        } catch {
            return url;
        }
    }

    async testLink(url, sourceUrl = '') {
        this.results.total++;
        
        // Skip anchor-only links on same page
        if (url.includes('#') && url.split('#')[0] === sourceUrl.split('#')[0]) {
            this.log(`Skipping anchor link: ${url}`, 'debug');
            this.results.skipped++;
            return { status: 'skipped', message: 'Anchor link' };
        }
        
        // Test external links
        if (!this.isInternalLink(url, this.options.baseUrl)) {
            this.external.add(url);
            const result = await this.testExternalUrl(url);
            
            if (result.status === 'success') {
                this.results.working++;
                this.log(`✓ External: ${url}`, 'success');
            } else if (result.status === 'skipped') {
                this.results.skipped++;
                this.log(`⏭ External: ${url} (skipped)`, 'debug');
            } else {
                this.results.broken++;
                this.broken.add({ url, source: sourceUrl, error: result.message });
                this.log(`✗ External: ${url} - ${result.message}`, 'error');
            }
            
            return result;
        }
        
        // Test internal links (local files)
        const filePath = this.getLocalFilePath(url, this.options.baseUrl);
        const exists = await this.testLocalFile(filePath);
        
        if (exists) {
            this.results.working++;
            this.log(`✓ Internal: ${url} → ${filePath}`, 'success');
            return { status: 'success', localPath: filePath };
        } else {
            this.results.broken++;
            this.broken.add({ url, source: sourceUrl, error: 'File not found', localPath: filePath });
            this.log(`✗ Internal: ${url} → ${filePath} (NOT FOUND)`, 'error');
            return { status: 'error', message: 'File not found', localPath: filePath };
        }
    }

    async crawlPage(url, depth = 0) {
        if (depth > this.options.maxDepth || this.visited.has(url)) {
            return;
        }
        
        this.visited.add(url);
        this.log(`Crawling: ${url} (depth: ${depth})`, 'info');
        
        try {
            // Read local file
            const filePath = this.getLocalFilePath(url, this.options.baseUrl);
            const fullPath = path.resolve(this.options.localPath, filePath);
            
            if (!fs.existsSync(fullPath)) {
                this.log(`Cannot read file: ${fullPath}`, 'error');
                return;
            }
            
            const html = fs.readFileSync(fullPath, 'utf8');
            const links = this.extractLinks(html, url);
            
            this.log(`Found ${links.length} links on ${url}`, 'debug');
            
            // Test all links on this page
            for (const link of links) {
                const normalizedUrl = this.normalizeUrl(link, url);
                if (normalizedUrl) {
                    const result = await this.testLink(normalizedUrl, url);
                    
                    // Recursively crawl internal pages
                    if (result.status === 'success' && 
                        this.isInternalLink(normalizedUrl, this.options.baseUrl) &&
                        !normalizedUrl.includes('#') &&
                        depth < this.options.maxDepth) {
                        await this.crawlPage(normalizedUrl, depth + 1);
                    }
                }
            }
            
        } catch (error) {
            this.log(`Error crawling ${url}: ${error.message}`, 'error');
        }
    }

    async run(startUrl = null) {
        const url = startUrl || path.join(this.options.baseUrl, 'index.html');
        
        this.log('🚀 Starting website link test...', 'info');
        this.log(`Base URL: ${this.options.baseUrl}`, 'info');
        this.log(`Local path: ${this.options.localPath}`, 'info');
        this.log(`Max depth: ${this.options.maxDepth}`, 'info');
        this.log(`Test external: ${this.options.testExternal}`, 'info');
        this.log('', 'info');
        
        await this.crawlPage(url);
        
        this.printResults();
    }

    printResults() {
        const duration = ((Date.now() - this.startTime) / 1000).toFixed(2);
        
        console.log('\n' + '='.repeat(60));
        console.log('📊 LINK TEST RESULTS');
        console.log('='.repeat(60));
        console.log(`⏱️  Duration: ${duration}s`);
        console.log(`📄 Pages crawled: ${this.visited.size}`);
        console.log(`🔗 Total links tested: ${this.results.total}`);
        console.log(`✅ Working links: ${this.results.working}`);
        console.log(`❌ Broken links: ${this.results.broken}`);
        console.log(`🌐 External links: ${this.results.external}`);
        console.log(`⏭️  Skipped links: ${this.results.skipped}`);
        
        if (this.broken.size > 0) {
            console.log('\n❌ BROKEN LINKS:');
            console.log('-'.repeat(40));
            Array.from(this.broken).forEach(item => {
                console.log(`🔗 ${item.url}`);
                console.log(`   Source: ${item.source}`);
                console.log(`   Error: ${item.error}`);
                if (item.localPath) {
                    console.log(`   Expected: ${item.localPath}`);
                }
                console.log('');
            });
        }
        
        if (this.external.size > 0 && this.options.verbose) {
            console.log('\n🌐 EXTERNAL LINKS FOUND:');
            console.log('-'.repeat(40));
            Array.from(this.external).forEach(url => {
                console.log(`   ${url}`);
            });
        }
        
        console.log('='.repeat(60));
        
        const success = this.results.broken === 0;
        console.log(success ? '🎉 All tests passed!' : '⚠️  Some links are broken');
        
        // Exit with error code if there are broken links
        process.exit(success ? 0 : 1);
    }
}

// CLI Interface
function parseArgs() {
    const args = process.argv.slice(2);
    const options = {
        verbose: false,
        external: false,
        depth: 3,
        timeout: 5000
    };
    let startUrl = null;
    
    for (const arg of args) {
        if (arg.startsWith('--depth=')) {
            options.depth = parseInt(arg.split('=')[1]) || 3;
        } else if (arg.startsWith('--timeout=')) {
            options.timeout = parseInt(arg.split('=')[1]) || 5000;
        } else if (arg === '--verbose') {
            options.verbose = true;
        } else if (arg === '--external') {
            options.external = true;
        } else if (arg === '--help' || arg === '-h') {
            console.log(`
Website Link Tester

Usage: node test-links.js [starting-url] [options]

Options:
  --depth=N     Maximum crawl depth (default: 3)
  --verbose     Show detailed output
  --external    Test external links too
  --timeout=N   Request timeout in ms (default: 5000)
  --help, -h    Show this help

Examples:
  node test-links.js                           # Test from index.html
  node test-links.js --verbose --external     # Verbose mode with external links
  node test-links.js --depth=2                # Limit crawl depth to 2
            `);
            process.exit(0);
        } else if (!startUrl && !arg.startsWith('--')) {
            startUrl = arg;
        }
    }
    
    return { startUrl, options };
}

// Main execution
if (require.main === module) {
    const { startUrl, options } = parseArgs();
    
    // Set up local testing environment
    options.baseUrl = 'http://localhost:8080';
    options.localPath = path.join(__dirname, 'src');
    
    const tester = new LinkTester(options);
    tester.run(startUrl).catch(error => {
        console.error('❌ Fatal error:', error.message);
        process.exit(1);
    });
}

module.exports = LinkTester;