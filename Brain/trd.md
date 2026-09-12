# FitKarma — Technical Requirements Document (TRD)

## 1. Platform requirements
- **Client**: Flutter 3.x, targeting Android (min API level per current Flutter stable support) and iOS; Web/Desktop responsive but not launch-priority.
- **Wearables**: Health Connect (Android), HealthKit (iOS) as the data ingestion path — no direct vendor SDK integrations at launch.
- **Backend**: Supabase (hosted Postgres, Auth, Storage, Edge Functions, Realtime).

## 2. Non-functional requirements
| Requirement | Target |
| :--- | :--- |
| Offline capability | All logging screens (meals, workouts, biometrics) must read/write locally (Drift) with zero network dependency; sync resumes automatically on reconnect. |
| AI response latency | DIP generation and coach responses should complete within a few seconds under normal network conditions; degrade to cached/last-known guidance if Groq is unreachable. |
| Data residency / compliance | DPDP Act 2023 — cascading right-to-erasure, user data isolation via RLS, no cross-user data leakage. |
| Localization | Full bilingual Hindi/English UI; vernacular voice logging extends to Hinglish, Tamil, Telugu (P16). |
| Test coverage | 145/145 existing unit/widget tests must keep passing through the migration; RLS policies require pgTAP coverage. |
| Uptime (post-launch) | Best-effort on Supabase's hosted SLA; no self-managed infra at this stage. |

## 3. Third-party integrations
- **Groq** — multi-model AI router (Llama-3.3-70b, Mixtral, Llama-3.2-11b vision), server-side only.
- **RevenueCat** — subscription entitlement management, server-verified webhooks.
- **Firebase Cloud Messaging** — push notifications only (Supabase has no native equivalent).
- **Sentry** — crash and Edge Function error monitoring.
- **Meta WhatsApp Business Cloud API** — logging via chat (P16).
- **ABDM/ABHA** — health ID linkage, M1 token exchange, FHIR record sync (P16).
- **Quick-commerce vendors** (Blinkit, Zepto, Swiggy Instamart, BigBasket, Amazon Fresh) — price matrix, see `scrapping_spec.md` and `data_sources.md`.
- **AdMob** — ad monetisation on the Free tier, see `admob_spec.md`.

## 4. Data & storage requirements
- Postgres with Row Level Security as the sole access-control mechanism for user data (see `data_model.md`, `security.md`).
- Local encrypted cache (Drift + SQLCipher) as the offline source of truth for the UI.
- Supabase Storage (private buckets, signed URLs) for photos, food vision snaps, and clinical PDF dossiers.

## 5. Environments
- **Local/dev**: Supabase local dev stack (`supabase start`) for schema iteration and Edge Function testing.
- **Staging**: separate Supabase project, used for RevenueCat sandbox, ABHA sandbox, and pre-release QA.
- **Production**: production Supabase project; ABHA and RevenueCat switched to live credentials only at production_checklist sign-off.

## 6. Constraints
- Solo-founder development — architecture choices must favor low operational overhead (managed services over self-hosted infra) wherever the compliance/feature requirements allow it.
- No AI API key or Supabase service-role key ever ships in the client binary.
