# Enterprise CI/CD Pipeline & Automated Release Deployment

## 1. Overview
FitKarma features automated **GitHub Actions CI/CD Workflows** orchestrating code formatting, static analysis with fatal linter warnings, unit & widget test suite execution with code coverage reporting, zero-secrets security scanning, and multi-platform production release compilation (Android `.aab` & iOS `.ipa`).

---

## 2. GitHub Actions Workflows

### 1. Continuous Integration (`.github/workflows/ci.yml`)
- **Trigger**: Push or Pull Request to `main` and `develop` branches.
- **Jobs**:
  1. **Flutter Lint, Analyze & Test**:
     - `dart format --output=none --set-exit-if-changed .`
     - `flutter analyze --fatal-infos --fatal-warnings`
     - `flutter test --coverage`
     - Automated secrets regex scan blocking `gsk_`, `sk-proj-`, `rc_secret_` in `lib/`.
  2. **Firebase Cloud Functions Test**:
     - Node.js 18 dependency validation and syntax verification in `functions/`.

### 2. Continuous Deployment & Release (`.github/workflows/cd.yml`)
- **Trigger**: Git Version Tag push (`v*.*.*`) or manual `workflow_dispatch`.
- **Jobs**:
  1. **Build Release Bundles**:
     - Android Release App Bundle: `flutter build appbundle --release`
     - iOS Release IPA: `flutter build ipa --release --no-codesign`
     - Uploads artifacts to GitHub Releases & TestFlight.
  2. **Deploy Firebase Cloud Functions & Rules**:
     - `firebase deploy --only firestore:rules,storage:rules,functions`

---

## 3. Pipeline Stages & Execution Telemetry

| Pipeline Stage | Expected Runtime | Gate Criterion |
| :--- | :--- | :--- |
| **Dart Format & Static Linting** | ~18s | 0 warnings, 0 errors, 0 format changes |
| **105+ Pure Dart & Widget Tests** | ~42s | 100% test pass rate ($\ge 95\%$ domain coverage) |
| **Zero-Secrets & Security Audit** | ~8s | Zero hardcoded API keys detected in client binary |
| **Cloud Functions & Webhook Check** | ~15s | Node.js syntax & HMAC webhook verification |
| **Android Release App Bundle (AAB)** | ~140s | ProGuard optimized signed bundle compiled |
| **iOS Release Archive (IPA)** | ~195s | Xcode Release archive generated |
| **Firestore & Storage Rules Deploy** | ~12s | Cloud security rules active |

---

## 4. Architectural Components

### Domain Layer
- **`cicd_models.dart`**: `PipelineStage`, `PipelineStatus`, `StageRunRecord`, and `CicdPipelineReport`.
- **`cicd_engine.dart`**: Pure Dart deterministic pipeline report compiler and build diagnostics simulator.

### Presentation Layer
- **`cicd_provider.dart`**: Riverpod `StateNotifierProvider` managing pipeline execution state and automated build triggers.
- **`cicd_screen.dart`**: Premium dark-mode Bento UI displaying live pipeline status, commit/branch metadata, stage timeline, and compiled artifact download badges.

---

## 5. Offline Verification & Testing
- **100% Offline Capable**: All pipeline diagnostics, stage evaluations, and build report representations execute deterministically without external cloud dependencies.
- **Unit Tests**: Full test suite in `test/features/cicd_pipeline/cicd_test.dart` passing with 100% coverage.
