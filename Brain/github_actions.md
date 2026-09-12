# FitKarma — GitHub Actions (CI/CD)

## 1. Workflow overview
| Workflow | Trigger | Purpose |
| :--- | :--- | :--- |
| `flutter-ci.yml` | PR to `main`/`develop`, push to `develop` | `flutter analyze`, unit + widget tests (145+ suite), build check (Android + iOS) |
| `supabase-migrate.yml` | Push to `main` touching `supabase/migrations/**` | Apply schema migrations to staging, then production on tagged release |
| `edge-functions-deploy.yml` | Push to `main` touching `supabase/functions/**` | Deploy Edge Functions via `supabase functions deploy` |
| `rls-test.yml` | PR touching `supabase/migrations/**` or `supabase/tests/**` | Run `supabase test db` (pgTAP) against a local Supabase instance |
| `release.yml` | Tag push (`v*`) | Build signed Android AAB / iOS archive, upload to Play Console internal track / TestFlight |
| `dependency-audit.yml` | Scheduled (weekly) | `flutter pub outdated`/audit and Deno dependency check for Edge Functions |

## 2. `flutter-ci.yml` (representative outline)
```yaml
on:
  pull_request:
    branches: [main, develop]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test --coverage
```

## 3. Supabase migration deploy
```yaml
on:
  push:
    branches: [main]
    paths: ['supabase/migrations/**']
jobs:
  migrate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: supabase/setup-cli@v1
      - run: supabase link --project-ref ${{ secrets.SUPABASE_STAGING_REF }}
      - run: supabase db push
```
Production migration is a separate job gated on a tagged release, using `SUPABASE_PROD_REF` and requiring the RLS test workflow to have passed on the same commit.

## 4. Secrets required (GitHub Actions → Repo Secrets)
- `SUPABASE_STAGING_REF`, `SUPABASE_PROD_REF`, `SUPABASE_ACCESS_TOKEN`
- `SUPABASE_SERVICE_ROLE_KEY` (staging/prod, used only inside deploy jobs, never echoed to logs)
- `GROQ_API_KEY`, `REVENUECAT_WEBHOOK_SECRET`, `META_WHATSAPP_TOKEN`, `ABDM_CLIENT_SECRET`, `SENTRY_AUTH_TOKEN`
- Android signing (`ANDROID_KEYSTORE_BASE64`, etc.) and iOS signing (App Store Connect API key) for `release.yml`

## 5. Branch strategy
- `main` — production-tracking; only merges from `develop` via reviewed PR.
- `develop` — integration branch; feature branches merge here first.
- Feature branches named per `TODO.md` phase/item (e.g. `phase4-wearable-sync`).

## 6. Gating rules
- No merge to `main` without `flutter-ci.yml` and `rls-test.yml` (where applicable) passing.
- No production Supabase migration without a corresponding staging migration having already run clean.
- No release build (`release.yml`) triggered off an untagged commit.
