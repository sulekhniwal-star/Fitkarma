# Project Structure

## 1. Feature Description
Defines and bootstraps the complete directory layout, Flutter client configuration, Firebase Cloud Functions foundation, security rules, and module boundaries for FitKarma.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-A, §P0-B, §P0-C, §P0-D, §P0-H, README.md)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `pubspec.yaml`: Locked Flutter dependencies (Riverpod, Firebase suite, Hive, Google Fonts, flutter_animate, RevenueCat, local_auth).
- `analysis_options.yaml`: Linting rules for Dart codebase consistency.
- `firebase.json`: Emulator configuration for auth, functions, firestore, storage, and UI.
- `firestore.rules`: Base Firestore security rules enforcing per-user data isolation under `/users/{userId}`.
- `storage.rules`: Cloud Storage security rules restricting access to user-owned buckets.
- `functions/package.json` & `functions/index.js`: Firebase Cloud Functions backend structure with modular subdirectories (`healthOS`, `aiRouter`, `webhooks`).
- `lib/main.dart`: Flutter root application entry point wrapped with `ProviderScope`.
- `lib/core/constants/app_constants.dart`: Global constants and collection names.
- `lib/shared/theme/app_theme.dart`: Base dark theme definition with brand palette.
- `docs/project_structure/project_structure.md`: Comprehensive folder structure and modular encapsulation specification.

## 4. Firestore Collections & Fields
- **Data paths defined:**
  - `/users/{userId}` and all subcollections (`dailyLogs`, `meals`, `workouts`, `healthOS`, `karma`, `clinicalReports`).
  - `/squads/{squadId}`, `/clubs/{clubId}`, `/cohortBenchmarks/{cohortKey}`, `/marketplace/{listingId}`.
- **Rule enforcement:** `firestore.rules` and `storage.rules` configured to disallow unauthorized reads/writes.

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** Directory layout enforces that deterministic math/logic resides in client repositories and helper libraries in pure Dart.
- **AI Logic:** Cloud Functions (`functions/aiRouter/`) isolate server-side Groq multi-model invocations away from the client.

## 6. Deviations from Spec
- None. Fully adheres to the Flutter 3.x + Riverpod 2.x + Firebase locked stack.
