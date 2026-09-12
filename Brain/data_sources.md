# FitKarma — Data Sources

## 1. Market & feature research
- Two years of independent market research via a Google Form survey informed the 16-phase feature roadmap and target personas (see `prd.md`). This is qualitative/product input, not a live data feed.

## 2. Nutrition database (P5)
- Seed set: 500+ regional Indian recipes, street foods, and festival adaptations — curated/compiled manually (not scraped), stored in the `recipes` table.
- Micronutrient reference values: standard published Indian food composition references (e.g. IFCT-style composition tables) used as the baseline for macro/micronutrient fields — verify licensing terms before bundling any dataset wholesale.
- Ongoing additions should go through the same manual curation/review process as the seed set to keep data quality consistent — this is not an auto-scraped table.

## 3. Grocery pricing (P16)
- Vendors: Blinkit, Zepto, Swiggy Instamart, BigBasket, Amazon Fresh, local Kirana (via WhatsApp).
- Preferred path: official partner/affiliate APIs where available.
- Fallback path: scraping, scoped and rate-limited per `scrapping_spec.md` — treat as a last resort per vendor, since ToS terms vary and can change without notice.
- Data lands in `grocery_price_matrix`, refreshed on a schedule, with a `source` column (`api` | `scrape` | `manual`) so downstream code can weight confidence.

## 4. Environmental health (P15)
- AQI: a government or public AQI API (e.g. CPCB-published data or a reputable aggregator) — pick one with an official India-focused feed rather than a global proxy, and record the exact endpoint/provider in `decisions.md` once chosen.
- UV index / Wet-Bulb Heat Index: standard meteorological API providers.

## 5. Wearables & biometrics (P4, P10)
- Health Connect (Android) and HealthKit (iOS) — on-device aggregation layers; FitKarma reads through these rather than integrating individual wearable vendor SDKs.
- CGM data: whichever CGM vendor SDK/export format is targeted first should be documented here once selected (currently unspecified — flag as an open decision).

## 6. India digital health rails (P16)
- ABDM/ABHA: official ABDM sandbox and API documentation for M1 token exchange, 14-digit ABHA validation, and FHIR record sync.
- WhatsApp: Meta WhatsApp Business Cloud API official documentation.

## 7. Data provenance rule
Every non-user-generated table (`recipes`, `grocery_price_matrix`, cohort benchmark inputs) must carry a `source` and `last_verified_at`-style column so stale or third-party-sourced data can be audited and refreshed independently of the app release cycle.
