# Phase -1 — Repo, Environments & CI/CD Setup Guide

## Executed Status & Repo Configuration

1. **Git Branches Verified**:
   - `develop` (Staging target)
   - `main` (Production target)
2. **CI/CD Workflow Configured**:
   - `.github/workflows/ci-cd.yml` configured with multi-environment deployment steps:
     - Pull requests & pushes execute `test` and `test-workers`.
     - Pushes to `develop` deploy Cloudflare Workers & D1 migrations to **Staging**.
     - Pushes to `main` deploy to **Production** (requires GitHub environment approval).
3. **Environment Configuration File Created**:
   - Created `wrangler.toml` with `[env.staging]` and `[env.production]` sections.
4. **Cloudflare D1 Databases Provisioned**:
   - `fitkarma-db-staging`: `39cc4384-437f-44d8-939c-65325dff0fa7`
   - `fitkarma-db-production`: `bd8e12fe-2f17-4d42-a847-930d41f90fd5`

---

## Post-Build Deployment Steps (To be performed during Phase 14 / Pre-Launch)

To complete live credentials configuration before deployment:

### 1. Cloudflare Secrets Configuration
Run the following commands in your terminal to store production & staging keys in Cloudflare:
```bash
npx wrangler secret put GROQ_API_KEY --env staging
npx wrangler secret put GOOGLE_OAUTH_CLIENT_ID --env staging
npx wrangler secret put JWT_SIGNING_SECRET --env staging

npx wrangler secret put GROQ_API_KEY --env production
npx wrangler secret put GOOGLE_OAUTH_CLIENT_ID --env production
npx wrangler secret put JWT_SIGNING_SECRET --env production
```

### 2. Google OAuth Web Client Setup (No SHA-1 required)
1. Go to **Google Cloud Console → APIs & Services → Credentials**.
2. Click **Create Credentials → OAuth client ID**.
3. Select **Web application**.
4. Set Redirect URI to your Cloudflare Worker domain: `https://fitkarma-api.workers.dev/auth/google/callback`.

### 3. GitHub Repository Secrets Setup
In **GitHub Repo → Settings → Secrets and variables → Actions**, set:
- `CF_ACCOUNT_ID`: Cloudflare Account ID
- `CF_API_TOKEN_STAGING`: Cloudflare API Token for Staging
- `CF_API_TOKEN_PRODUCTION`: Cloudflare API Token for Production
