---
name: fitkarma-build
description: "Use this skill whenever working on the FitKarma repository — implementing a feature, fixing a bug, writing tests, or touching any file under lib/, functions/, or docs/. FitKarma is a Flutter + Firebase health/fitness app for the Indian market being built solo, feature by feature, from TODO.md. This skill defines the mandatory workflow, coding conventions, and documentation rules for this specific repo. Always consult TODO.md before starting work and FitKarma_Documentation_v2.md for architecture/spec detail on the feature in question."
---

# FitKarma Build Skill

This file is the operating manual for any AI coding agent working in this repository. `TODO.md` is the **sole work-order list** — do not start work that isn't represented as an unchecked item there, and do not mark an item done until every sub-requirement below is satisfied.

## 1. Before touching code

1. Read `TODO.md` top to bottom and find the next unchecked item in phase order (phases are sequential — do not jump ahead to a later phase while earlier-phase items are unchecked, unless the user explicitly says to).
2. Open `FitKarma_Documentation_v2.md` and read the relevant `§P#-#` section (and the Phase summary in `§P0-G`) for that feature's spec — data model, screens, formulas, AI vs. deterministic split.
3. Confirm the tech stack for anything you're about to write against `§P0-A` — Dart/Flutter, Riverpod, Firestore, Cloud Functions in JavaScript. Do not introduce a different framework, database, or backend language without the user explicitly changing the locked stack.

## 2. While building

- **Deterministic logic** (scores, formulas, thresholds — anything marked "Pure Dart — No AI" or "Deterministic" in the doc) is implemented in Dart, unit-testable, and works fully offline.
- **AI logic** (coaching responses, meal photo analysis, narrative summaries) is implemented server-side in a Cloud Function only. The client never calls Groq directly and never embeds an AI API key.
- **Firestore access** goes through a repository/service layer (one per feature, e.g. `lib/features/nutrition/data/nutrition_repository.dart`), not scattered raw `FirebaseFirestore.instance` calls across widgets.
- **State management** is Riverpod providers/notifiers per feature — follow the pattern of whatever feature was built immediately before it for consistency.
- **Security rules**: any new Firestore collection or Cloud Storage path needs a corresponding rule added to `firestore.rules` / `storage.rules` in the same change — never ship a new collection with default-open rules.
- **Offline behavior**: every screen that logs data must work with no network connection (Firestore offline persistence handles this by default — verify, don't assume).

## 3. Documentation requirement — every feature gets its own README

**This is mandatory, not optional.** When a feature listed in `TODO.md` is completed:

1. Create (or update) a `README.md` inside that feature's folder (e.g. `lib/features/readiness_engine/README.md`).
2. The feature README must cover:
   - What the feature does (1–2 sentences, user-facing)
   - Which `§P#-#` section of `FitKarma_Documentation_v2.md` it implements
   - Key files and their responsibility (screen, repository, provider, Cloud Function if any)
   - Firestore collections/fields it reads or writes
   - Whether it's deterministic, AI-backed, or both — and where the split happens
   - Any deviations from the spec doc, and why
3. Only after the README is written does the corresponding `TODO.md` checkbox get marked complete. A feature without a README is not considered done.

## 4. Definition of done for any TODO.md item

- [ ] Code implemented per the spec section referenced
- [ ] Works offline where the spec requires it
- [ ] Firestore/Storage security rules updated if new data paths were added
- [ ] Feature README.md written (see §3)
- [ ] TODO.md checkbox ticked, in the same commit/change as the above

## 5. When the spec and reality conflict

If `FitKarma_Documentation_v2.md` is ambiguous or a formula/flow doesn't make sense once you're implementing it, don't silently improvise a replacement — flag it to the user and note the discrepancy in the feature README's "deviations" line once resolved.
