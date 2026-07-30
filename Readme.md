# FitKarma

**India's Intelligent Health Operating System** — an offline-first, AI-adaptive fitness,
nutrition, and wellness platform built for the Indian market.

FitKarma isn't a tracker. It's a decision engine: a **Health OS Brain** generates one
orchestrated Daily Intelligence Package (DIP) each morning, and every module — coach,
nutrition, workout, recovery — reads from that single source instead of making its own
repeated AI calls.

Full product/architecture spec: [`Fitkarma_documentation.md`](./Fitkarma_documentation.md)
(15 development phases, 60+ ADRs, full DB schema, all Worker code).
Agent/IDE context: [`.agent/skills/fitkarma-dev/SKILL.md`](./.agent/skills/fitkarma-dev/SKILL.md).

---

## Tech Stack

| Layer | Technology |
|---|---|
| App | Flutter 3.x, Riverpod 2.x |
| Local DB | Drift (SQLite) + SQLCipher (AES-256, CSPRNG-keyed) |
| Backend | Cloudflare Workers (compute/API) + Cloudflare D1 (SQLite at the edge) + R2 (object storage) |
| Fan-out jobs | Cloudflare Workflows (daily DIP generation, per-user error isolation) |
| Auth | Self-rolled JWT (jose, HS256) in a Worker — email OTP + Google/Apple Sign-In, D1-backed |
| AI | Groq, multi-model tiered routing via the AI Router — never called directly from the client |
| Pose estimation | MediaPipe (on-device) |
| Billing | RevenueCat |
| Monitoring | Sentry |
| CI/CD | GitHub Actions |

**Why Cloudflare, not a single managed BaaS:** in Feb 2026 India blocked Supabase
(`*.supabase.co`) under IT Act Section 69A with no warning. FitKarma deliberately avoids
depending on any single foreign SaaS domain for a critical path — Cloudflare's footprint
in India's own internet infrastructure makes it a far less plausible block target, and
self-rolled auth means there's no third-party identity provider to lose either.

---

## Repository Structure

```
fitkarma/
├── .github/workflows/ci-cd.yml     # test → staging → production pipeline
├── .agent/skills/fitkarma-dev/     # Antigravity IDE skill (project context for AI agents)
├── lib/                            # Flutter app
│   ├── core/                       # Health OS Brain, AI Router, Decision Hierarchy
│   ├── data/                       # Drift schema, sync layer, D1 client
│   ├── features/                   # onboarding, coach, nutrition, workout, social, ...
│   └── shared/                     # design system, shared widgets
├── workers/                        # Cloudflare Workers (backend)
│   ├── src/                        # fitkarma-health-os, fitkarma-coach, fitkarma-whatsapp, ...
│   ├── migrations/                 # D1 schema migrations
│   ├── wrangler.toml                # NOT committed — copy from wrangler.toml.example
│   └── wrangler.toml.example       # dev / staging / production environment definitions
├── Fitkarma_documentation.md       # master spec (source of truth)
├── TODO.md                         # phase-by-phase launch checklist
└── README.md
```

---

## Environments — Development, Staging, Production (one repo)

FitKarma runs **two live Cloudflare environments plus a local dev setup**, all from this
one repository, using `wrangler.toml`'s `[env.*]` blocks and Flutter's `--dart-define`:

| | Local dev | Staging | Production |
|---|---|---|---|
| Branch | any feature branch | `develop` | `main` |
| Cloudflare Worker | `wrangler dev` (local) | `fitkarma-api-staging` | `fitkarma-api` |
| D1 database | `fitkarma-db-dev` | `fitkarma-db-staging` | `fitkarma-db-production` |
| JWT signing secret | local `.dev.vars` | unique per-env secret | unique per-env secret |
| Flutter flavor | `--flavor staging --dart-define=ENVIRONMENT=staging` (point at local Worker) | same flavor, staging URLs | `--flavor production --dart-define=ENVIRONMENT=production` |
| Deploys | manual (`wrangler dev`) | automatic, on every push to `develop` | automatic, on every push to `main` — **only after all CI checks pass** |

**Never share a JWT signing secret across environments** — a staging-issued token must
never authenticate against production data.

### One-time setup

```bash
npm install -g wrangler
wrangler login

cd workers
cp wrangler.toml.example wrangler.toml

# Create the two remote databases
wrangler d1 create fitkarma-db-staging
wrangler d1 create fitkarma-db-production
# Paste the returned database_id values into wrangler.toml under
# [env.staging] and [env.production]

# Set per-environment secrets (repeat with --env production)
wrangler secret put GROQ_API_KEY --env staging
wrangler secret put GOOGLE_OAUTH_CLIENT_ID --env staging
wrangler secret put JWT_SIGNING_SECRET --env staging
```

In **GitHub → Settings → Secrets and variables → Actions**, add:

- `CF_ACCOUNT_ID`
- `CF_API_TOKEN_STAGING`, `CF_API_TOKEN_PRODUCTION` (scoped Cloudflare API tokens)
- `CF_D1_API_BASE_URL_STAGING` / `_PRODUCTION`, `CF_WORKERS_API_BASE_URL_STAGING` / `_PRODUCTION`
- `GOOGLE_OAUTH_CLIENT_ID_STAGING` / `_PRODUCTION`, `SENTRY_DSN_STAGING` / `_PRODUCTION`
- `ANDROID_KEYSTORE_BASE64` (release signing key, production builds only)

In **GitHub → Settings → Environments**, create a `production` environment and add
**required reviewers** — this is what makes "deploy after every requirement is met" a
hard gate rather than a suggestion: the `deploy-production` job in the pipeline literally
cannot run until someone approves it, on top of every automated check passing.

---

## CI/CD Pipeline

Defined in [`.github/workflows/ci-cd.yml`](./.github/workflows/ci-cd.yml). Branch model:

```
feature/* ──PR──► develop ──push──► [test] ──► [deploy-staging] ──► [build-android-staging]
                                                       │
                                      (QA on staging, then PR develop → main)
                                                       ▼
                    main ──push──► [test] ──► [deploy-production] ──► [build-android/ios-production] ──► [create-release]
                                       (requires manual approval on the `production` GitHub Environment)
```

- **Every PR** (into `develop` or `main`) runs `test` + `test-workers` only — nothing
  deploys off a PR.
- **Push to `develop`** runs tests, then deploys Workers + D1 migrations to **staging**,
  then produces a debug APK for internal testers.
- **Push to `main`** runs tests, then — only if `test` and `test-workers` both pass, and
  a required reviewer approves the `production` environment — deploys Workers + D1
  migrations to **production**, builds signed Android/iOS release artifacts, and cuts a
  GitHub Release. If any upstream job fails, nothing downstream runs; there is no partial
  production deploy.

---

## Local Development

```bash
git clone <repo-url> && cd fitkarma
flutter pub get
dart run build_runner build --delete-conflicting-outputs

# Point the app at a locally running Worker
cd workers && wrangler dev &
cd ..
flutter run --flavor staging --dart-define=ENVIRONMENT=staging \
  --dart-define=CF_WORKERS_API_BASE_URL=http://localhost:8787
```

Run tests the same way CI does:

```bash
flutter analyze --fatal-infos
flutter test --coverage
cd workers && npm test
```

---

## Documentation

- [`Fitkarma_documentation.md`](./Fitkarma_documentation.md) — full spec: Health OS Brain,
  AI Router, all 16 phases, D1 schema, all 8 Workers, 60+ ADRs.
- [`TODO.md`](./TODO.md) — phase-by-phase launch checklist derived from the spec.
- [`.agent/skills/fitkarma-dev/SKILL.md`](./.agent/skills/fitkarma-dev/SKILL.md) — context
  for AI coding agents (Antigravity IDE) working in this codebase.

## License

Proprietary — © FitKarma. Not licensed for external use or redistribution.