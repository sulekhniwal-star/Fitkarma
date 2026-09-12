# FitKarma — Production Checklist

## 1. Security & compliance
- [ ] RLS policy audit complete on every table (owner-only access verified via pgTAP, no default-open tables).
- [ ] `delete_user_data` cascade tested end-to-end against a production-shaped dataset (staging).
- [ ] Legal/medical review of all health-related claims and coaching copy complete.
- [ ] Terms of Service and Privacy Policy finalized, reflecting the DPDP compliance mechanism in `security.md` §5 verbatim.
- [ ] Ads consent flow reviewed against DPDP + AdMob's own policy requirements (`admob_spec.md` §6).
- [ ] Vendor ToS status for grocery scraping fallback confirmed per vendor (`scrapping_spec.md` §2), no vendor scraped without a recorded decision.

## 2. Infrastructure
- [ ] Production Supabase project provisioned separately from staging, with its own credentials.
- [ ] Supabase project network/SSL settings reviewed.
- [ ] Service-role key confirmed absent from client build artifacts (grep the built binary/bundle, don't just check source).
- [ ] Backup/point-in-time-recovery enabled on the production Postgres instance.
- [ ] GitHub Actions secrets fully populated for production deploy jobs (`github_actions.md` §4).

## 3. Third-party production readiness
- [ ] RevenueCat switched from sandbox to production API keys; webhook endpoint verified against production traffic.
- [ ] ABHA/ABDM credentials switched from sandbox to production, with ABDM's required approval/certification complete.
- [ ] Meta WhatsApp Business account verified for production messaging.
- [ ] Sentry projects split (or environment-tagged) for staging vs. production so noise doesn't mix.
- [ ] AdMob app reviewed and approved by Google, ad units live-tested on a real device build.

## 4. App store readiness
- [ ] Play Console / App Store Connect listings complete (screenshots, privacy labels matching actual data collection, DPDP-aligned data-safety disclosures).
- [ ] Signed release builds produced via `release.yml`, not a local ad-hoc build.
- [ ] Crash-free session rate checked against a minimum bar (via Sentry) on the release candidate before submission.

## 5. Monitoring & rollback
- [ ] Sentry alerting configured for Edge Function error-rate spikes and RLS-denial spikes.
- [ ] Rollback plan documented for a bad Supabase migration (staging-tested down-migration or restore-from-backup path).
- [ ] On-call/notification path defined (even if it's just "founder gets a Sentry email/Slack alert") for production incidents.

## 6. Milestone-specific (college submission, per `prd.md` §9)
- [ ] Demo build has working monetisation (purchase flow completes end-to-end in a test/sandbox environment acceptable for a demo).
- [ ] Demo script/flow rehearsed against the actual current feature set (not the full 16-phase roadmap) to avoid overpromising to evaluators.
