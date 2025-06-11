# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a website development repository for the Cloud Data Consulting website. The site will be built using vanilla HTML, CSS, and JavaScript without any build tools or external dependencies. All content, styling, and functionality is managed here for complete control and portability.

## Architecture

The repository follows a simple, modern web development approach:

- **HTML/CSS/JS Only**: No frameworks, no TypeScript, no build process
- **AI-Assisted Development**: Use prompts to generate content and code
- **Version Control**: All website code and content tracked in Git
- **Modular Structure**: Components organized for easy maintenance

## Workflow

1. Use prompts in `/prompts/` with Claude to generate structured content and code
2. Create HTML pages with semantic structure
3. Style with modern CSS (Flexbox, Grid, custom properties)
4. Add interactivity with vanilla JavaScript
5. Test locally and deploy as static files

## Directory Structure

- `prompts/` — AI prompts for content and code generation
- `content/` — Website content organized by section (markdown format)
- `src/` — HTML, CSS, and JS files (to be created)
- `assets/` — Images, fonts, and other static assets (to be created)
- Root level planning and configuration files

## Development Commands

This is a static HTML/CSS/JS project without build tools:

```bash
# No build process required
# Open HTML files directly in browser for local testing
# Use any local server for development if needed (python -m http.server, etc.)
```

## Technology Constraints

- **HTML**: Semantic HTML5 only
- **CSS**: Modern CSS without preprocessors (use custom properties, Grid, Flexbox)
- **JavaScript**: Vanilla ES6+ only, no TypeScript
- **No Dependencies**: No npm packages, no build tools, no frameworks
- **Browser Support**: Modern browsers (ES6+ support required)

## Important Notes

- All code must be vanilla HTML/CSS/JS
- No external dependencies or frameworks
- Focus on semantic, accessible markup
- Use modern CSS features for styling
- Keep JavaScript simple and functional