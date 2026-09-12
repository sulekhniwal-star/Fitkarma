# Enterprise Hardening, Security & CI/CD (FitKarma Phase 14)

FitKarma's Enterprise Hardening suite ensures compliance with India's Digital Personal Data Protection (DPDP) Act 2023, automated CI/CD gating, and performance budgeting.

---

## Key Capabilities

1. **DPDP Act 2023 Compliance & Cascading Erasure (`delete-user-data` Edge Function)**:
   - Server-side cryptographic deletion across 38+ user-scoped relational tables and private storage buckets (`progress-photos`, `lab-reports`, `doctor-dossiers`).
   - Immutable anonymized `erasure_receipts` generation with SHA-256 audit hashing.

2. **Security & PII Sanitization (`SecurityAuditService`)**:
   - Automated Sentry error capture scrubbers removing Indian phone numbers (`+91`), ABHA Health IDs, passwords, PINs, and JWTs before transmission.
   - Deterministic SHA-256 cohort hashing for privacy-safe analytics.

3. **Performance Monitoring & Budgeting (`PerformanceMonitor`)**:
   - Traces cold startup time (< 1.2s target), UI frame rendering thresholds (60fps / 16.6ms), and local SQLite query execution latencies (< 100ms).
   - Real-time health score calculation based on latency budgets.

4. **CI/CD Automation (GitHub Actions)**:
   - `flutter-ci.yml`: Static analysis + test suite validation with LCOV coverage.
   - `supabase-migrate.yml`: Automated schema migration sync.
   - `rls-test.yml`: pgTAP Row-Level Security verification against staging database.
   - `release.yml`: Release bundling and signing for Google Play Console & TestFlight.
