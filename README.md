# Cloud Data Consulting — Website Development

This repository contains the complete website for Cloud Data Consulting, built using vanilla HTML, CSS, and JavaScript without any external dependencies or build tools. The site is developed using AI-assisted workflows for rapid iteration and content generation.

## 🎯 Technology Stack

- **HTML5**: Semantic markup for accessibility and SEO
- **CSS3**: Modern CSS with custom properties, Grid, and Flexbox
- **JavaScript ES6+**: Vanilla JavaScript for interactivity
- **No Dependencies**: No frameworks, no build tools, no npm packages

## 🧠 Development Workflow

1. **Generate Content** using AI prompts in `/prompts/`
2. **Create HTML Pages** with semantic structure in `/src/`
3. **Style with CSS** using modern CSS features
4. **Add Interactivity** with vanilla JavaScript
5. **Test Locally** by opening HTML files in browser

## 📁 Project Structure

```
cloud-data-consulting-site/
├── src/                    # Website source files
│   ├── index.html         # Homepage
│   ├── about.html         # About page
│   ├── services.html      # Services page
│   ├── contact.html       # Contact page
│   ├── css/               # Stylesheets
│   │   ├── main.css       # Main styles
│   │   └── components.css # Component styles
│   └── js/                # JavaScript files
│       └── main.js        # Main functionality
├── assets/                # Static assets
│   ├── images/            # Images and graphics
│   └── fonts/             # Custom fonts (if any)
├── content/               # Content in markdown format
│   ├── services/          # Service descriptions
│   └── blog/              # Blog content
├── prompts/               # AI prompts for generation
│   └── website-builder-prompt.md
└── wireframe/             # Legacy wireframe content
```

## 🚀 Getting Started

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd cloud-data-consulting-site
   ```

2. **Open locally**
   ```bash
   # Open index.html directly in browser or use a local server
   python -m http.server 8000  # If you want a local server
   ```

3. **Start developing**
   - Edit HTML files in `/src/`
   - Modify styles in `/src/css/`
   - Add JavaScript in `/src/js/`

## 🎨 Design System

- **Colors**: Professional blue (#3156CF), dark blue (#002B7F), orange accent (#F79743)
- **Typography**: System fonts for fast loading and accessibility
- **Layout**: CSS Grid and Flexbox for responsive design
- **Components**: Modular CSS classes for reusability

## ✨ Key Features

- Fully responsive design
- Semantic HTML for accessibility
- Modern CSS without preprocessors
- Vanilla JavaScript for enhanced UX
- Fast loading with no external dependencies
- SEO optimized structure

## 🔧 Development Notes

- All code must be vanilla HTML/CSS/JS
- No build process required
- Focus on semantic, accessible markup
- Use modern CSS features (custom properties, Grid, Flexbox)
- Keep JavaScript simple and functional
- Browser support: Modern browsers with ES6+ support 
