# Webflow CMS Schema — Cloud Data Consulting

This document outlines the recommended CMS Collections and fields for the new Webflow (or Relume-exported) site.  
Use this as a reference for manual setup or for scripting API-based publishing later.

---

## 1. Blog Posts

| Field Name      | Type        | Required | Notes                                  |
|-----------------|-------------|----------|----------------------------------------|
| Name            | Plain Text  | Yes      | Title of the blog post                 |
| Slug            | Slug        | Yes      | Auto-generated or custom               |
| Main Image      | Image       | Yes      | Hero/cover image                       |
| Summary         | Plain Text  | Yes      | Short excerpt for previews             |
| Body            | Rich Text   | Yes      | Main content (HTML/Markdown supported) |
| Author          | Reference   | No       | Link to Authors collection             |
| Publish Date    | Date/Time   | Yes      |                                        |
| Tags            | Multi-ref   | No       | Link to Tags collection                |
| SEO Title       | Plain Text  | No       | For meta tags                          |
| SEO Description | Plain Text  | No       | For meta tags                          |

---

## 2. Case Studies

| Field Name      | Type        | Required | Notes                                  |
|-----------------|-------------|----------|----------------------------------------|
| Name            | Plain Text  | Yes      | Title of the case study                |
| Slug            | Slug        | Yes      |                                        |
| Client Logo     | Image       | No       |                                        |
| Summary         | Plain Text  | Yes      | Short description                      |
| Body            | Rich Text   | Yes      | Main content                           |
| Services Used   | Multi-ref   | No       | Link to Services collection            |
| Results         | Plain Text  | No       | Key outcomes/metrics                   |
| Publish Date    | Date/Time   | No       |                                        |

---

## 3. Services

| Field Name      | Type        | Required | Notes                                  |
|-----------------|-------------|----------|----------------------------------------|
| Name            | Plain Text  | Yes      | Service name                           |
| Slug            | Slug        | Yes      |                                        |
| Icon            | Image/SVG   | No       |                                        |
| Description     | Plain Text  | Yes      | Short summary                          |
| Details         | Rich Text   | Yes      | Full description                       |
| CTA Text        | Plain Text  | No       | Button/CTA label                       |
| CTA Link        | URL         | No       |                                        |

---

## 4. Authors (Optional)

| Field Name      | Type        | Required | Notes                                  |
|-----------------|-------------|----------|----------------------------------------|
| Name            | Plain Text  | Yes      | Author's name                          |
| Bio             | Rich Text   | No       | Short bio                              |
| Photo           | Image       | No       |                                        |
| LinkedIn        | URL         | No       |                                        |

---

## 5. Tags (Optional)

| Field Name      | Type        | Required | Notes                                  |
|-----------------|-------------|----------|----------------------------------------|
| Name            | Plain Text  | Yes      | Tag name                               |
| Slug            | Slug        | Yes      |                                        |

---

## Usage Notes

- These collections cover all core content types for a B2B consulting/agency site.
- You can add or remove fields as needed in Webflow Designer.
- For API publishing, match field names exactly as defined in Webflow.

_Last updated: 2025-06-08_
