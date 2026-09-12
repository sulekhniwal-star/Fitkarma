# FitKarma — Product Requirements Document (PRD)

## 1. Vision
FitKarma is India's intelligent health operating system: one app that unifies fitness, nutrition, sleep, biomarkers, and Ayurvedic context into a daily actionable plan, built specifically for Indian food, language, and health infrastructure (ABHA, WhatsApp, quick-commerce) rather than a localized Western fitness app.

## 2. Problem statement
Existing fitness apps (MyFitnessPal, HealthifyMe, Cult.fit) either ignore Indian food/recipe diversity, don't integrate with India's digital health rails (ABHA/ABDM), or require constant connectivity in a market where network reliability varies. Users are left manually estimating Indian meals against Western food databases and get generic coaching that ignores Ayurvedic self-understanding many Indian users already reason in.

## 3. Target users / personas
- **Primary**: urban/semi-urban Indians, 20–40, smartphone-first, price-sensitive, want practical guidance in Hindi/Hinglish or English.
- **Secondary**: corporate wellness program members (via the Insurer/Corporate tier).
- **Tertiary**: doctors/clinicians receiving shared dossiers from patients using the app.

## 4. Core value propositions
1. Deep Indian nutrition database (500+ recipes, regional/festival/street-food variants) instead of Western food databases.
2. Daily Intelligence Package (DIP) — one AI-synthesized daily plan instead of a dozen disconnected trackers.
3. Works offline-first — logging doesn't stop when connectivity does.
4. Ayurvedic framing (Dosha scoring) alongside clinical metrics, meeting users where their existing health vocabulary is.
5. India-specific trust layer: WhatsApp logging, vernacular voice logging, ABHA integration, quick-commerce grocery pricing.

## 5. Feature scope (by phase — see `architechture.md` and `data_model.md` for implementation detail)
- **Foundational (P0–P4)**: onboarding, Dosha scoring, women's health, daily readiness, AI adaptive coach, wearable-integrated health tracking.
- **Nutrition & training (P5–P8)**: Indian nutrition engines, workout system with pose estimation, gamification, transformation journey tracking.
- **Social & predictive (P9–P13)**: squads/clubs, predictive health (CGM, biological age, doctor dossiers), visual body analytics, festival/travel modes, monetisation tiers.
- **Enterprise & trust (P14–P16)**: security hardening, advanced metabolic/longevity intelligence, WhatsApp/vernacular/ABHA/corporate/grocery integrations.

## 6. Out of scope (for now)
- Clinical diagnosis or treatment recommendations (informational/coaching only — legal review pending before any medical claims ship).
- Non-Indian market localization.
- Native wearable hardware.

## 7. Monetisation
- **Free**: core tracking, ad-supported (see `admob_spec.md`).
- **Karma Pro**: ad-free, full AI coaching, nutrition engines.
- **FitKarma Elite**: predictive health, doctor dossiers, biological age, priority AI.
- **Corporate/Insurer tier**: B2B, per-seat, dashboards via FitKarma Hub.
- Target margin on Elite: ~30% after processor fees (revised down from an initial ~60% assumption as new tiers are introduced).

## 8. Success metrics
- Activation: % of onboarded users completing first DIP within 24h.
- Retention: D7/D30 habit-streak retention (Karma points as the leading indicator).
- Nutrition engagement: meals logged via OCR/voice vs. manual entry ratio.
- Monetisation: Free→Pro conversion rate, Elite attach rate on corporate accounts.

## 9. Launch plan
1. **Milestone 1 (near-term)**: demoable build for college major-project submission, including working monetisation, presented to placement-cell evaluators.
2. **Milestone 2**: legal/medical/trainer review of health claims and Terms/Privacy Policy.
3. **Milestone 3**: broader public/startup launch.

## 10. Risks
- ABHA/ABDM integration complexity and approval timelines.
- Grocery price data reliability if scraping (see `scrapping_spec.md`) is disrupted by vendor ToS changes.
- Solo-founder bandwidth against a 16-phase roadmap.
