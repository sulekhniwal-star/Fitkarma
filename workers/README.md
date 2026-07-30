# Cloudflare Workers Module (`workers/`)

## Purpose
Contains Cloudflare Workers microservices serving as FitKarma's edge backend API, D1 database migrations, and Cloudflare Workflows fan-out jobs.

## Structure
- **`src/`**: TypeScript source files for Worker endpoints (`fitkarma-health-os`, `fitkarma-coach`, etc.).
- **`migrations/`**: Edge SQL schema migrations for Cloudflare D1.
- **`wrangler.toml`**: Cloudflare environments configuration file (`staging` and `production` environments).
