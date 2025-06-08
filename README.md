# Cloud Data Consulting — Site Content & AI Workflow

This repo is the foundation for building, iterating, and managing the content, layout, and structure of the Cloud Data Consulting website using Claude (and later Cline, ChatGPT, or others). The live site is currently being built in [Webflow](https://webflow.com), but all copy, embedded code, and reusable sections will be managed here in Git for version control and future portability.

## 🧠 Workflow Overview

1. **Prompt Claude** using files in `/prompts` to generate structured content.
2. **Save generated sections** to `/content/` or `/embeds/` as `.md` or `.html` files.
3. **Paste content** into Webflow manually (Designer or CMS).
4. (Optional) Automate CMS publishing via [Webflow API](https://developers.webflow.com/docs/api-reference/).
5. (Later) Port to Astro or Hugo if needed using `/content` structure.

## 📁 Folder Structure

- `prompts/` — Markdown prompts for Claude, GPT, or other LLMs.
- `content/` — Site content (markdown or HTML sections).
  - `use-cases/`, `blog/`, `services/`, etc.
- `embeds/` — HTML/JS for interactive or reusable blocks.
- `scripts/` — (Optional) Python or shell scripts for interacting with APIs.
- `webflow-export/` — (Optional) exported code from Webflow if hosting externally.
- `.env` — Store API keys for Claude, Webflow, etc. (ignored by Git).

## 🚀 Recommended Tools

- [Claude Code](https://claude.ai/)
- [Cline](https://github.com/ericmjl/cline)
- [ChatGPT CLI or Aider](https://github.com/paul-gauthier/aider)
- GitHub + VS Code for collaboration and versioning

## 🗺️ Next Steps

1. Run `git init` and push this repo to GitHub.
2. Use the `/prompts/homepage-hero.md` with Claude to generate your homepage intro.
3. Save the result to `/content/homepage-hero.md` and paste it into Webflow.
4. Repeat for service pages, CTAs, testimonials, etc.

---

Recommended Repo structure
cloud-data-site/
├── .gitignore
├── README.md
├── prompts/
│   ├── homepage-hero.md
│   ├── ai-readiness-service.md
│   └── tone-guide.md
├── content/
│   ├── use-cases/
│   └── blog/
├── embeds/
│   ├── contact-form.js
│   └── cta-section.html
├── webflow-export/         # optional later
│   └── index.html
├── scripts/                # optional for API calls or blog publishing
└── .env
