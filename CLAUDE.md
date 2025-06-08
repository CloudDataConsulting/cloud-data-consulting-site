# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a content and workflow management repository for the Cloud Data Consulting website. The live site is built in Webflow, but all copy, embedded code, and reusable sections are managed here for version control and future portability.

## Architecture

The repository follows a content-first approach:

- **Prompts → Content → Webflow**: Generate structured content using AI prompts, save to `/content/`, then manually paste into Webflow
- **Version Control**: All website content is tracked in Git for collaboration and future migration
- **Modular Structure**: Content is organized by type (use-cases, blog, services) for easy management

## Workflow

1. Use prompts in `/prompts/` with Claude to generate structured content
2. Save generated sections to `/content/` or embed HTML to root level
3. Manually paste content into Webflow (Designer or CMS)
4. Optional: Use Webflow API for automated publishing
5. Future: Migrate to static site generator using `/content` structure

## Directory Structure

- `prompts/` — AI prompts for content generation (currently contains homepage-hero.md)
- `content/` — Site content organized by section (markdown or HTML)
- Root level files like `webflow-embeds.html` contain reusable HTML/JS blocks
- `site-notes.md` and `prompts.ai.md` are project planning files

## Content Generation Commands

Since this is a content-focused repository without build tools, the primary workflow involves:

```bash
# Use Claude to process prompts and generate content
# No specific build, test, or lint commands - this is a content repository
```

## Important Notes

- Content files may be empty initially - they serve as placeholders for generated content
- The repository is designed for AI-assisted content creation workflow
- All website copy should be version controlled here before going to Webflow