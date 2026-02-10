# YOURA Sleep

A Rails app that connects to the Oura Ring API so you can sign in, import your Oura data, and eventually view it in dashboards and export it in useful formats.

**Stack:** Ruby 3.2.2 · Rails 8.1 · PostgreSQL · [Tailwind CSS](https://github.com/rails/tailwindcss-rails) · [esbuild](https://esbuild.github.io/) (via [jsbundling-rails](https://github.com/rails/jsbundling-rails)) for JavaScript bundling · Hotwire (Turbo, Stimulus)

---

## What works now (Phase 1)

- [x] Users can sign up and sign in (Devise)
- [x] Users can connect their Oura account via OAuth
- [x] Oura data is imported and stored as raw payloads (sleep, daily_sleep, daily_activity, daily_readiness, and other v2 usercollection types)
- [x] Raw payloads are listed and viewable per data type and date range

---

## Roadmap

### Phase 2 — Group & export

- [ ] Group imported data in a meaningful way (e.g. by week, by metric)
- [ ] Support exporting grouped data (e.g. CSV, structured formats)

### Phase 3 — Dashboards

- [ ] **Overview** — High-level summary and key metrics
- [ ] **Sleep** — Sleep-focused charts and grouped data
- [ ] **Stress** — Stress metrics and trends
- [ ] **Health** — Broader health metrics (readiness, activity, etc.)

All dashboards will use charts and grouped data instead of raw JSON.

---

## Setup

- Ruby (see `.ruby-version`), PostgreSQL, Node.js
- `bin/setup` — installs gems, runs `npm install`, builds JS, prepares DB
- Configure `.env` with Oura OAuth credentials (`OURA_CLIENT_ID`, `OURA_CLIENT_SECRET`, `OURA_REDIRECT_BASE_URL`, `OURA_SCOPES`)
- `bin/dev` — runs Rails, JS watch, and Tailwind
