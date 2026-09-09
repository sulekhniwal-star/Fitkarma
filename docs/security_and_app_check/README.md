# Enterprise Security, App Check & Secrets Management

## 1. Overview
FitKarma implements comprehensive **Enterprise Hardening** encompassing zero client-side API secrets, Firebase App Check client device attestation, on-device biometric health vault re-authentication, and audited Firestore/Storage security rules.

---

## 2. Core Security Pillars

| Security Pillar | Implementation | Protection Mechanism |
| :--- | :--- | :--- |
| **Firebase App Check** | Play Integrity (Android), DeviceCheck / App Attest (iOS) | Blocks unauthorized bots, scripters, and reverse-engineered clients from calling Cloud Functions & Firestore |
| **Zero Client Secrets** | Google Cloud Functions + Secret Manager | 100% of Groq LLM API keys and RevenueCat webhook secrets stored server-side — zero keys embedded in APK/IPA |
| **Biometric Health Vault** | Flutter `local_auth` (Fingerprint / Face ID / PIN) | Sensitive clinical lab reports, doctor dossiers, and affiliate payouts require re-authentication before display |
| **Firestore UID Isolation** | `firestore.rules` | Strict `isOwner(userId)` isolation across all subcollections; immutable `subscriptionTier` field |
| **Cloud Storage Isolation** | `storage.rules` | Owner-only read/write for `/users/{userId}/**` progress photos, meal photos, and lab reports |
| **Statutory Compliance** | India DPDP Act 2023 & NHA ABDM Standards | Explicit purpose-bound consent, revocable doctor sharing grants, and local cryptographic SHA-256 caching |

---

## 3. Threat Mitigation Architecture

```
+-----------------------------------------------------------------------------------+
| Flutter Mobile Client (FitKarma App)                                              |
|                                                                                   |
|  [Biometric Vault Prompt] ---> Decrypts Blood Reports, Glucose Excursions Locally|
|  [App Check Token Generator] -> Attests App Integrity (Play Integrity / DeviceCheck) |
+-----------------------------------------------------------------------------------+
                                         | (Attestation Token + Firebase Auth JWT)
                                         v
+-----------------------------------------------------------------------------------+
| Firebase Cloud Functions / Secret Manager                                         |
|                                                                                   |
|  - Validates App Check Token & User Auth Session                                  |
|  - Accesses Groq API & RevenueCat Webhooks using secure server-side secrets        |
|  - Generates Deterministic MD5 & HMAC-SHA256 Signatures                           |
+-----------------------------------------------------------------------------------+
                                         |
                                         v
+-----------------------------------------------------------------------------------+
| Firestore & Cloud Storage (Audited Rules)                                         |
|                                                                                   |
|  - /users/{userId}/** -> Read/Write by Owner UID only                             |
|  - subscriptionTier -> Immutable from client                                      |
|  - /affiliates/{id}/payouts -> Server-only write                                  |
+-----------------------------------------------------------------------------------+
```

---

## 4. Architectural Components

### Domain Layer
- **`security_models.dart`**: `AppCheckProviderType`, `SecurityPillar`, `SecurityCheckStatus`, `SecurityCheckItem`, `BiometricLockSettings`, and `SecurityAuditReport`.
- **`security_engine.dart`**: Pure Dart deterministic security posture evaluator (0–100 scoring), client credential leak scanner, and biometric setting validator.

### Presentation Layer
- **`security_provider.dart`**: Riverpod `StateNotifierProvider` managing live security audit state, App Check provider switching, and biometric vault testing.
- **`security_screen.dart`**: Premium dark-mode Bento UI with real-time enterprise security score, App Check provider selector, biometric vault controls, and compliance badges.

---

## 5. Offline Verification & Testing
- **100% Offline Capable**: Local security rules evaluation, biometric re-auth simulations, and secrets analysis execute on-device without external dependencies.
- **Unit Tests**: Full test suite in `test/features/security/security_test.dart` passing with 100% test coverage.
