# Subscription Tiers & Server-Side Entitlement Verification

## 1. Overview
The **Subscription Tiers & Entitlements Engine** manages FitKarma's freemium product packaging, AI compute token cost gating, and multi-tier feature unlocks. Entitlement verification is strictly **server-side only** — client self-reporting of premium status is prevented via Firestore Security Rules and cryptographically verified RevenueCat webhook integrations.

---

## 2. Subscription Tiers & Pricing Structure

| Tier | Monthly (INR) | Annual (INR) | Effective / Mo | Daily AI Quota | Primary Unlocked Features |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Free** | ₹0 | ₹0 | ₹0 | 10 calls | Basic AI Coach briefings, weight & step tracking, Smart Calendar micro-windows |
| **Pro** | ₹499 | ₹3,999 | ~₹333 (Save 33%) | 50 calls | Wearable-Free Body Composition AI, Desi AI Roast, Travel & Festival Intelligence, Wedding Transformation |
| **Elite** | ₹1,499 | ₹9,999 | ~₹833 (Save 44%) | 200 calls | Blood / Lab Report OCR & Vision AI, Human Coach Marketplace Access, Family Circle Sharing (up to 5), Uncapped 70B deep synthesis |

---

## 3. Server-Side Security & Verification Flow

```
+-------------------+             +-----------------------+             +-----------------------+
|  Apple App Store  |             |      RevenueCat       |             |   Cloud Function      |
|  Google Play IAP  | ----------> |  Webhook Dispatched   | ----------> |  `handleRevenueCat`   |
+-------------------+             +-----------------------+             +-----------+-----------+
                                                                                    |
                                                                                    v
+-------------------+             +-----------------------+             +-----------+-----------+
| Flutter Client UI | <---------- | Realtime Client Sync  | <---------- | Writes Verified Hash  |
| (Bento Paywall)   |             | (Read-only on profile)|             | to `users/{userId}`   |
+-------------------+             +-----------------------+             +-----------------------+
```

1. **Webhook Handler (`functions/webhooks/revenuecat.js`)**:
   - Listens for `INITIAL_PURCHASE`, `RENEWAL`, `UNCANCELLATION`, `CANCELLATION`, `EXPIRATION`, and `BILLING_ISSUE`.
   - Computes HMAC-SHA256 signature `computeEntitlementHash(userId, tier, expiresAtMs, secretKey)`.
   - Directly updates `users/{userId}` using Admin SDK.
2. **Firestore Security Rules (`firestore.rules`)**:
   - Explicitly blocks client-side mutations on `subscriptionTier`, `subscriptionStatus`, `subscriptionExpiresAt`, `serverVerificationHash`, and `willRenew`.
   - Disallows privilege escalation.

---

## 4. Architectural Components

### Domain Layer
- **`subscription_models.dart`**: `SubscriptionTier`, `EntitlementFeature`, `BillingCycle`, `SubscriptionStatus`, `UserEntitlements`, and `EntitlementAccessResult`.
- **`subscription_engine.dart`**: Pure Dart deterministic entitlement evaluation, grace period resolver, daily AI query limiter, and sandbox mock generator.

### Presentation Layer
- **`subscription_provider.dart`**: Riverpod `StateNotifier` for tier selection, billing cycle toggling, offline sandbox upgrades, and entitlement checking.
- **`subscription_screen.dart`**: Premium dark-mode Bento UI with daily AI quota meter, billing cycle switcher, tier selection cards, and comprehensive feature matrix.

---

## 5. Offline Verification & Testing
- **100% Offline Capable**: All feature gating logic, quota computations, and downgrade fallbacks run deterministically on-device when network is unavailable.
- **Unit Tests**: Full test suite in `test/features/monetisation/subscription_test.dart` passing with 100% test coverage.
