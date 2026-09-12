# FitKarma — AdMob Spec

## 1. Purpose
AdMob monetises the **Free** tier only. Karma Pro, FitKarma Elite, and Corporate/Insurer tiers are fully ad-free — ad state is derived from the `entitlements` table (server-verified via RevenueCat webhook, see `data_model.md`, `api_contract.md`), never from a client-side flag alone.

## 2. Ad placements (allow-list, not a block-list)
Ads are only permitted on screens explicitly listed here — any new screen is ad-free by default until added to this list intentionally:
- Home dashboard footer banner (non-intrusive, below the fold of the primary readiness card).
- Nutrition browse/recipe list (native/inline ad units between recipe cards, clearly labeled "Ad").
- Post-workout summary screen (interstitial, capped — see frequency rules below).

## 3. Explicitly excluded surfaces
No ad unit, of any format, ever appears on:
- Dosha assessment, women's health/cycle tracking screens.
- Any biomarker, CGM, or predictive health (biological age) screen.
- Doctor dossier share flow.
- Onboarding.
- Coach chat interface.
This is a hard product rule, not a configuration default — a new ad placement on any of these screens requires a `decisions.md` entry and explicit sign-off, not just a config toggle.

## 4. Ad formats
- **Banner**: home dashboard footer only.
- **Native/inline**: nutrition recipe browse only, styled to match the Bento card system (see `ui_spec.md`) rather than a generic AdMob template, so it doesn't visually clash with the glassmorphism design.
- **Interstitial**: post-workout summary only, frequency-capped (see below). No interstitials on app open/close or navigation between core screens.
- **Rewarded**: not currently in scope; revisit only if a specific "unlock X for watching an ad" feature is designed.

## 5. Frequency capping
- Interstitials: no more than once per session, and not on a user's first N workouts post-onboarding (grace period to avoid hurting activation).
- Banner/native units: standard AdMob refresh intervals, no aggressive re-serving.

## 6. Consent & compliance
- Ad personalization consent is collected as part of the same consent flow that covers DPDP data-processing consent — not a separate, easy-to-miss dialog.
- Users who decline personalized ads still see non-personalized ads on the Free tier (contextual, not targeted) rather than being blocked from the Free tier entirely.
- AdMob app ID and client-side SDK keys are public-by-design and may live in client build config; anything beyond that (mediation network keys, if added later) follows `security.md` §3.

## 7. Tier transition behavior
- Upgrading from Free to Pro/Elite mid-session should hide ad units immediately once the `entitlements` row updates (via Realtime subscription or a manual refresh after purchase confirmation) — no "ads until app restart" gap.
- Downgrade/expiry (subscription lapse) re-enables ads on the next entitlement check, not immediately mid-session in a jarring way.

## 8. Open items
- Mediation network selection (single-network AdMob vs. mediation stack) — not yet decided; log the decision in `decisions.md` once made.
- Whether Corporate/Insurer tier B2B seats ever see ads under any sub-tier — currently assumed no, confirm with pricing model before launch.
