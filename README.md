# Gabriele Fontana — Personal Website

The official source code for [gafreax.github.io](https://gafreax.github.io), the personal website and technical portfolio of Gabriele Fontana.

## Design Philosophy

The website adopts an **Editorial Minimal** aesthetic inspired by classic print broadsheets and technical journals. It pairs expressive editorial serif typography with crisp body text and monospaced technical accents:

- **Zero Build Dependencies**: Pure HTML5, modern CSS3, and vanilla JavaScript. No Node.js runtime, bundling, transpilation, or third-party frameworks required.
- **Dual Theme Support**: Native Light and Dark themes with automatic system color-scheme detection, persistent `localStorage` preference, and URL query override (`?theme=dark` / `?theme=light`).
- **Accessible & Semantic**: Rigorous HTML semantic structure (`<header>`, `<main>`, `<footer>`, single `<h1>`), accessible ARIA controls, and responsive layout.
- **GitHub Pages Ready**: Includes `.nojekyll` to bypass Jekyll pipeline processing and deploy raw static files directly.

## Repository Structure

```
├── .nojekyll                       # Disables Jekyll processing on GitHub Pages
├── index.html                      # Homepage: Bio, talks, articles, projects & community
├── article-container-at-war.html   # Full technical debrief: "Container at War"
├── style.css                       # Complete design system, typography & theme variables
├── main.js                         # Pure vanilla JS theme switcher & persistence
├── scripts/
│   └── test-html.sh                # Quality & regression verification script
└── README.md                       # Project documentation
```

## Local Preview

Because there is no build step, you can serve the repository using any local HTTP server:

### Python 3 (Recommended)
```bash
python3 -m http.server 8000
```
Then navigate to `http://localhost:8000` in your web browser.

### Alternative Quick Servers
```bash
# Using PHP
php -S localhost:8000

# Using Node (if already installed)
npx serve .
```

## Running Verification Tests

A lightweight, zero-dependency validation script is included in `scripts/test-html.sh`. It verifies:
- Existence of core static assets.
- Semantic HTML tags, doctype, viewport meta, titles, and landmark elements (`<header>`, `<main>`, `<footer>`, exactly one `<h1>`).
- Internal link validity (ensuring anchor destinations and linked `.html` files exist).
- Core CSS theme variables (`--bg`, `--text-primary`, `--font-display`, `--font-mono`, `[data-theme="dark"]`).

Execute the test suite:
```bash
./scripts/test-html.sh
```

## Author

- **Gabriele Fontana** — [@gafreax](https://github.com/gafreax)
