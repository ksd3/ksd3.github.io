# Quarto Website Guide

A comprehensive guide to working with this Quarto-based personal website.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Directory Structure](#directory-structure)
3. [Quick Start](#quick-start)
4. [Building the Site](#building-the-site)
5. [Layout and Design](#layout-and-design)
6. [Blog Posts](#blog-posts)
7. [Talks (Presentations)](#talks-presentations)
8. [Books (Textbooks)](#books-textbooks)
9. [CV and Resume](#cv-and-resume)
10. [Landing Pages](#landing-pages)
11. [Styling](#styling)
12. [Deployment](#deployment)
13. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required

- **Quarto** (v1.3+): https://quarto.org/docs/get-started/
  ```bash
  quarto --version
  ```

### Required for PDF Generation

- **Typst**: https://typst.app/
  ```bash
  typst --version
  ```

### Optional

- **Chrome/Chromium** (for RevealJS → PDF conversion)

### Installation

```bash
# Install Quarto (Linux/macOS via Homebrew)
brew install quarto

# Install Typst
brew install typst

# Or download from:
# - Quarto: https://quarto.org/docs/download/
# - Typst: https://github.com/typst/typst/releases
```

---

## Directory Structure

```
ksd3.github.io/
├── _quarto.yml           # Main site configuration
├── styles.css            # Custom CSS (dark mode, layout, typography)
├── guide.md              # This guide
│
├── index.qmd             # Home page
├── research.qmd          # Research page
├── talks.qmd             # Talks listing page
├── textbooks.qmd         # Books listing page
├── cv.qmd                # Resume/CV landing page (embeds PDFs)
│
├── blog/                 # Blog posts
│   ├── index.qmd         # Blog listing (auto-generated)
│   ├── 2024-05-01-bu-courses/   # Example: Courses post
│   ├── 2024-12-01-partitioning/
│   └── YYYY-MM-DD-slug/  # Post template
│       └── index.qmd
│
├── talks/                # Presentations
│   └── _template/        # Template for new talks
│       ├── index.qmd     # RevealJS + Typst output
│       └── images/
│
├── books/                # Textbooks
│   └── _template/        # Template for new books
│       ├── _quarto.yml   # Book config
│       ├── index.qmd
│       ├── chapter1.qmd
│       └── chapter2.qmd
│
├── cv/                   # CV and Resume (Typst PDF only)
│   ├── cv.qmd            # Full academic CV → cv.pdf
│   └── resume.qmd        # One-page resume → resume.pdf
│
├── images/               # Shared images
├── videos/               # Video files
└── docs/                 # Generated output (deploy this)
```

---

## Quick Start

```bash
# Build CV/Resume PDFs first (required for cv.qmd page)
quarto render cv/resume.qmd
quarto render cv/cv.qmd

# Preview the site locally (hot reload)
quarto preview

# Build the entire site
quarto render
```

The site opens at `http://localhost:4000` during preview.

---

## Building the Site

### Full Build (Recommended)

```bash
# Build PDFs first, then site
quarto render cv/resume.qmd && quarto render cv/cv.qmd && quarto render
```

### Selective Builds

```bash
# Single page
quarto render research.qmd

# Single blog post
quarto render blog/2024-05-01-bu-courses/index.qmd

# Single talk (generates HTML + PDF)
quarto render talks/YYYY-talk-name/

# Single book (generates HTML + PDF)
quarto render books/my-book/

# CV/Resume PDFs
quarto render cv/cv.qmd
quarto render cv/resume.qmd
```

---

## Layout and Design

### Site Layout

The site uses a **wide layout** inspired by gwern.net:

```
┌─────────────────────────────────────────────────────────┐
│  Home   Blog   Research   Textbooks   Talks   Resume/CV │  ← navbar
├────────────┬────────────────────────────────────────────┤
│ ON THIS    │                                            │
│ PAGE       │  Main Content                              │
│            │                                            │
│ Section 1  │  Wide layout (up to 1400px)               │
│ Section 2  │  Serif body text, sans-serif headings      │
│ Section 3  │                                            │
└────────────┴────────────────────────────────────────────┘
   TOC sidebar    (fixed, shows page sections)
```

### Key Features

- **Wide content area**: Up to 1400px max-width
- **Left TOC sidebar**: Shows current page sections (sticky, scrollable)
- **Dark mode**: Auto-detects system preference
- **Typography**: Serif body (Source Serif Pro), sans headings (Source Sans Pro)
- **Navbar**: Top navigation for site sections

### Dark Mode

Dark mode is automatic based on system preference (`prefers-color-scheme`). No toggle needed—it follows your OS setting.

---

## Blog Posts

### Creating a New Post

1. Create a directory:
   ```bash
   mkdir blog/YYYY-MM-DD-slug
   ```

2. Create `blog/YYYY-MM-DD-slug/index.qmd`:
   ```yaml
   ---
   title: "Post Title"
   author: "Kshitij Duraphe"
   date: "2025-01-18"
   categories: [category1, category2]
   description: "Brief description for listings"
   ---

   Your content here in markdown...
   ```

3. Preview:
   ```bash
   quarto preview blog/YYYY-MM-DD-slug/index.qmd
   ```

### Blog Features

- **Auto-sorting** by date (newest first)
- **Categories** with counts
- **RSS feed** at `/blog/index.xml`
- **TOC sidebar** for long posts

### Example Post Structure

```
blog/2025-01-18-my-post/
├── index.qmd           # Main content
├── images/             # Post-specific images
│   └── figure1.png
└── data/               # Optional data files
```

---

## Talks (Presentations)

Talks output **RevealJS** (HTML slides) and **Typst** (PDF download).

### Creating a New Talk

1. Copy the template:
   ```bash
   cp -r talks/_template talks/YYYY-talk-name
   ```

2. Edit `talks/YYYY-talk-name/index.qmd`:
   ```yaml
   ---
   title: "Talk Title"
   subtitle: "Conference Name 2025"
   author: "Kshitij Duraphe"
   date: "2025-01-18"
   format:
     revealjs:
       theme: simple
       slide-number: true
     typst:
       papersize: presentation-16-9
   ---

   ## Slide 1
   Content here...

   ## Slide 2
   More content...
   ```

3. Build:
   ```bash
   quarto render talks/YYYY-talk-name/
   ```

4. Add entry to `talks.qmd`:
   ```markdown
   ### Talk Title
   *January 2025 — Conference Name*

   Brief description.

   [View Slides](talks/YYYY-talk-name/index.html) | [PDF](talks/YYYY-talk-name/index.pdf)
   ```

### Slide Syntax

```markdown
## Regular Slide
Content here.

## Smaller Text {.smaller}
Lots of content...

## Two Columns
:::: {.columns}
::: {.column width="50%"}
Left content
:::
::: {.column width="50%"}
Right content
:::
::::

## Speaker Notes
Content visible to audience.

::: {.notes}
Notes only visible in speaker view (press 'S').
:::
```

---

## Books (Textbooks)

Books output **HTML** (read online) and **Typst** (PDF download).

### Creating a New Book

1. Copy the template:
   ```bash
   cp -r books/_template books/my-book
   ```

2. Edit `books/my-book/_quarto.yml`:
   ```yaml
   project:
     type: book
     output-dir: _book

   book:
     title: "Book Title"
     author: "Kshitij Duraphe"
     chapters:
       - index.qmd
       - chapter1.qmd
       - chapter2.qmd

   format:
     html:
       theme: cosmo
     typst:
       toc: true
       number-sections: true
   ```

3. Build:
   ```bash
   quarto render books/my-book/
   ```

4. Add entry to `textbooks.qmd`:
   ```markdown
   ### Book Title
   Description here.

   [Read Online](books/my-book/_book/index.html) | [PDF](books/my-book/_book/Book-Title.pdf)
   ```

### Book Features

- **Cross-references**: `@sec-intro`, `@fig-chart`, `@eq-formula`
- **Bibliography**: Add `references.bib`, cite with `[@key]`
- **Chapter navigation**: Auto-generated sidebar

---

## CV and Resume

CV and Resume are **Typst-only** (PDF output). The landing page embeds the PDFs.

### Workflow

1. Edit content in `cv/cv.qmd` or `cv/resume.qmd`

2. Build PDFs:
   ```bash
   quarto render cv/cv.qmd
   quarto render cv/resume.qmd
   ```

3. The `cv.qmd` landing page automatically embeds and links to the PDFs

### Using Typst Templates

Find templates at https://typst.app/universe (search "cv" or "resume").

```yaml
---
title: "Resume"
author: "Kshitij Duraphe"
format:
  typst:
    template: my-template.typ
    # Or use a package:
    include-in-header: |
      #import "@preview/modern-cv:0.7.0": *
---
```

### CV Structure

```markdown
# Name

email@example.com | github.com/username | linkedin.com/in/username

---

## Education

**University** | *Degree* | Year
- Details

## Experience

**Company** | *Role* | Dates
- Achievement with metrics

## Skills

**Languages:** Python, R, Julia
```

---

## Landing Pages

Landing pages are `.qmd` files in the root directory.

### Adding a New Page

1. Create `newpage.qmd`:
   ```yaml
   ---
   title: "Page Title"
   ---

   Content here...
   ```

2. Add to navbar in `_quarto.yml`:
   ```yaml
   website:
     navbar:
       left:
         - href: newpage.qmd
           text: New Page
   ```

### Two-Column Layout

```markdown
::: {layout="[30,70]"}
![](images/photo.jpg)

Text content in the larger column.
:::
```

---

## Styling

### CSS Overview

The site uses `styles.css` with:

- **CSS variables** for colors (light/dark mode)
- **Wide layout** (1400px max)
- **Fixed TOC sidebar** (200px)
- **Serif/sans typography**

### Key Variables

```css
:root {
  --bg-color: #fefefe;
  --text-color: #2c2c2c;
  --link-color: #1a5f7a;
  --border-color: #ddd;
  --bg-subtle: #f7f7f7;
  --sidebar-width: 200px;
  --content-max-width: 1400px;
}

@media (prefers-color-scheme: dark) {
  :root {
    --bg-color: #181818;
    --text-color: #e0e0e0;
    --link-color: #6db3c9;
    /* ... */
  }
}
```

### Multi-Column Content

Use CSS classes for multi-column layouts:

```markdown
::: {.columns-2}
- Item 1
- Item 2
- Item 3
- Item 4
:::
```

---

## Deployment

### GitHub Pages

1. Build the site:
   ```bash
   quarto render cv/resume.qmd && quarto render cv/cv.qmd && quarto render
   ```

2. Commit and push:
   ```bash
   git add .
   git commit -m "Update site"
   git push
   ```

3. In GitHub repo Settings → Pages:
   - Source: Deploy from a branch
   - Branch: `main`
   - Folder: `/docs`

### GitHub Actions (Automatic Builds)

Create `.github/workflows/publish.yml`:

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: quarto-dev/quarto-actions/setup@v2

      - name: Install Typst
        run: |
          curl -fsSL https://typst.community/typst-install/install.sh | sh
          echo "$HOME/.local/bin" >> $GITHUB_PATH

      - name: Build PDFs
        run: |
          quarto render cv/resume.qmd
          quarto render cv/cv.qmd

      - name: Render Site
        run: quarto render

      - name: Deploy
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs
```

---

## Troubleshooting

### Common Issues

**"Typst not found"**
```bash
brew install typst
# Or: https://github.com/typst/typst/releases
```

**PDFs not showing on cv.qmd page**
```bash
# Build the PDFs first
quarto render cv/resume.qmd
quarto render cv/cv.qmd
```

**TOC sidebar not appearing**
- Check that page doesn't have `toc: false` in front matter
- Sidebar only shows on pages with headings

**Dark mode not working**
- Check your OS dark mode setting
- Clear browser cache

**CSS not updating**
```bash
rm -rf .quarto
quarto render
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Preview site | `quarto preview` |
| Build everything | `quarto render cv/resume.qmd && quarto render cv/cv.qmd && quarto render` |
| Build single page | `quarto render page.qmd` |
| Build talk | `quarto render talks/name/` |
| Build book | `quarto render books/name/` |
| Build CV/Resume | `quarto render cv/cv.qmd` |

---

## Resources

- [Quarto Documentation](https://quarto.org/docs/)
- [Quarto Websites](https://quarto.org/docs/websites/)
- [Quarto Books](https://quarto.org/docs/books/)
- [Quarto Presentations](https://quarto.org/docs/presentations/)
- [RevealJS Options](https://quarto.org/docs/presentations/revealjs/)
- [Typst Documentation](https://typst.app/docs/)
- [Typst Universe (Templates)](https://typst.app/universe)
