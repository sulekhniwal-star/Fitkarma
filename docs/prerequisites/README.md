# Prerequisites & Bootstrap Setup

## 1. Feature Description
Establishes the developer environment requirements, dependency resolution, Firebase emulator configuration, and the unified app bootstrap initialization pipeline (`AppBootstrap`).

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (§P0-A Tech Stack, README.md)
- **Phase:** Phase 0 — Foundation

## 3. Key Files & Responsibilities
- `lib/core/bootstrap/app_bootstrap.dart`: Central app bootstrap pipeline orchestrating system UI overlays, Hive local offline caching, Firebase initialization, and global error handling.
- `lib/main.dart`: Root entry point running `AppBootstrap.initialize()` wrapped in Riverpod `ProviderScope`.
- `pubspec.yaml`: Locked Flutter dependencies.
- `test/widget_test.dart`: Automated widget smoke test verifying app startup.
- `docs/prerequisites/prerequisites.md`: Developer environment and Firebase emulator setup documentation.

## 4. Firestore Collections & Fields
- **Data paths:** None for local environment bootstrap.

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic environment setup and startup lifecycle.
- **AI Logic:** None.

## 6. Deviations from Spec
- None. Fully adheres to §P0-A specifications.
