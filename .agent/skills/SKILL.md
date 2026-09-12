---
name: fitkarma-build
description: "Use this skill whenever working on the FitKarma repository — implementing a feature, fixing a bug, writing tests, or touching any file under lib/, supabase/, or docs/. FitKarma is a Flutter + Supabase health/fitness app for the Indian market, built solo, feature by feature, from TODO.md. This skill defines the mandatory workflow, coding conventions, and documentation rules for this specific repo. Always consult TODO.md before starting work, and this doc suite (architechture.md, data_model.md, api_contract.md, etc.) for spec detail on the feature in question."
---

# FitKarma Build Skill (v2 — Supabase)

*(Filename kept as `skil.md` to match the requested file list — this is the successor to the earlier Firebase-era `fitkarma-build/SKILL.md`; replace that file's content with this once the migration is underway, rather than keeping two conflicting skill files active.)*

This file is the operating manual for any AI coding agent working in this repository. `TODO.md` is the **sole work-order list** — do not start work that isn't represented as an unchecked item there, and do not mark an item done until every sub-requirement below is satisfied. See `master_rules.md` for the fuller rules this skill is a condensed version of.

## 1. Before touching code
1. Read `TODO.md` top to bottom and find the next unchecked item in phase order (phases are sequential — don't jump ahead while earlier-phase items are unchecked, unless the user explicitly says to).
2. Open the relevant spec section for that feature: `architechture.md` for how it fits together, `data_model.md` for schema, `api_contract.md` for any Edge Function it calls, `ui_spec.md` for screens/components.
3. Confirm the tech stack against `trd.md`/`master_rules.md` §2 — Dart/Flutter, Riverpod, Drift+SQLCipher, Supabase (Postgres/Auth/Storage/Edge Functions), Groq server-side only. Do not introduce a different framework, database, or backend language without an explicit `decisions.md` entry.

## 2. While building
- **Deterministic logic** (scores, formulas, thresholds — anything marked "Pure Dart — No AI" or "Deterministic" in the spec) is implemented in Dart, unit-testable, and works fully offline.
- **AI logic** (coaching responses, meal photo analysis, narrative summaries) is implemented server-side in a Supabase Edge Function only. The client never calls Groq directly and never embeds an AI API key.
- **Supabase access** goes through a repository/service layer (one per feature, e.g. `lib/features/nutrition/data/nutrition_repository.dart`), not scattered raw Supabase client calls across widgets.
- **State management** is Riverpod providers/notifiers per feature — follow the pattern of whatever feature was built immediately before it for consistency.
- **RLS policies**: any new Postgres table or Storage bucket needs a corresponding RLS policy added in the same migration — never ship a new table with RLS disabled or default-open.
- **Offline behavior**: every screen that logs data must work with no network connection, via Drift-first writes and the sync outbox (see `architechture.md` §4) — verify this explicitly, don't assume it the way Firestore's cache used to provide for free.

## 3. Documentation requirement — every feature gets its own README
**This is mandatory, not optional.** When a feature listed in `TODO.md` is completed:
1. Create (or update) a `README.md` inside that feature's folder (e.g. `lib/features/readiness_engine/README.md`).
2. The feature README must cover:
   - What the feature does (1–2 sentences, user-facing)
   - Which spec section(s) it implements (reference `architechture.md`/`data_model.md`/`api_contract.md` sections)
   - Key files and their responsibility (screen, repository, provider, Edge Function if any)
   - Supabase tables/buckets it reads or writes, and confirmation RLS policies exist for them
   - Whether it's deterministic, AI-backed, or both — and where the split happens
   - Any deviations from the spec doc, and why
3. Only after the README is written does the corresponding `TODO.md` checkbox get marked complete. A feature without a README is not considered done.

## 4. Definition of done for any TODO.md item
- [ ] Code implemented per the spec section referenced
- [ ] Works offline where the spec requires it
- [ ] RLS policies added/updated if new tables/Storage paths were added, in the same change
- [ ] Feature README.md written (see §3)
- [ ] Relevant tests added (unit + RLS pgTAP where applicable — see `tedting.md`)
- [ ] `TODO.md` checkbox ticked, in the same commit/change as the above

## 5. When the spec and reality conflict
If a spec doc is ambiguous or a formula/flow doesn't make sense once you're implementing it, don't silently improvise a replacement — flag it to the user, and once resolved, log it in `decisions.md` and note the deviation in the feature README's "deviations" line.