# CV

My CV, written on Ruby on Rails — just for fun.

## 👉 Open the résumé here → **https://reonidok.github.io/CV/**

## About the résumé

The interactive résumé of **Leonid Kozhanov** — a full-stack engineer
(.NET / Angular) building business-critical financial systems and preparing to
relocate to Tokyo. It's styled as a retro, Japanese-flavoured pixel-art page:
a windowed "leonid.exe — 履歴書" layout with a hand-pixelled scene (the
character at a Mac, falling sakura petals, Mt. Fuji and a pagoda), covering the
summary, domain, tech stack, working style, experience, education, languages
(with a JLPT progress bar) and contacts.

Under the hood it's a small Rails 8 app: the content lives in a structured data
file and is rendered through ERB views, so there is no database to set up. The
pixel-art scenes are painted server-side with CSS `box-shadow`
(see [`app/helpers/pixel_art_helper.rb`](app/helpers/pixel_art_helper.rb)).

## Stack

- Ruby 3.4.9
- Rails 8.1
- Propshaft + Importmap + Hotwire (Turbo/Stimulus)
- No database (content is static, stored in `config/resume.yml`)

## Run locally

```bash
# 1. Ruby (via rbenv) — the version is pinned in .ruby-version
rbenv install 3.4.9   # skip if already installed

# 2. Gems
bundle install

# 3. Start the server
bin/rails server
```

Then open <http://localhost:3000> — that's the résumé.

Run the test suite with:

```bash
bin/rails test
```

## Edit the résumé

Content is data-driven: edit [`config/resume.yml`](config/resume.yml) and the
page updates automatically (no restart needed in development). Markup lives in
[`app/views/resume/`](app/views/resume/) and styling in
[`app/assets/stylesheets/application.css`](app/assets/stylesheets/application.css).
Theme colours are CSS custom properties on `.rk-page`.

## Deploy (GitHub Pages)

The résumé is a single static page, so it is published to GitHub Pages by
[`.github/workflows/pages.yml`](.github/workflows/pages.yml):

1. The workflow runs `bin/rails static:build`, which renders the page into a
   self-contained `dist/index.html` (CSS inlined, no JS — works at any URL).
2. The `dist/` directory is uploaded and deployed to GitHub Pages.

**One-time setup:** in the repo on GitHub, go to **Settings → Pages → Build and
deployment → Source** and select **GitHub Actions**. After that, every push to
`master` or `develop` (or a manual *Run workflow*) republishes the site.

Build and preview the static page locally:

```bash
bin/rails static:build
open dist/index.html
```
