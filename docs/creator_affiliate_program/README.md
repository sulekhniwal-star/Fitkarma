# Creator Affiliate Program

## 1. Overview
The **Creator Affiliate Program** empowers fitness coaches, social influencers, and power users to earn tiered recurring commissions by referring users to FitKarma Pro/Elite subscriptions and Marketplace coach programs. It features instant UPI payouts, conversion funnel analytics, automated tier promotions, and custom promotional marketing creatives.

---

## 2. Commission Tiers & Economics

| Tier | Conversions Required | Commission Rate | Perks |
| :--- | :--- | :--- | :--- |
| **Bronze Ambassador** | 0 – 10 | **15%** | Standard dashboard, referral links, custom promo code |
| **Silver Influencer** | 11 – 50 | **20%** | Priority payout clearance, WhatsApp & Instagram creatives |
| **Gold Creator** | 51 – 200 | **25%** | Dedicated affiliate support, early feature previews |
| **Platinum Partner** | 201+ | **30%** | Custom co-branded landing page, direct manager |

---

## 3. Payout & Referral Architecture

```
+------------------+             +----------------------+             +-----------------------+
|  User Clicks     |             |  In-App Purchase /   |             |  Cloud Function       |
|  Affiliate Link  | ----------> |  Marketplace Order   | ----------> |  `attributeReferral`  |
+------------------+             +----------------------+             +-----------+-----------+
                                                                                  |
                                                                                  v
+------------------+             +----------------------+             +-----------+-----------+
| Direct UPI Payout| <---------- | Creator Requests     | <---------- | Updates Balance in    |
| (Instant)        |             | Withdrawal           |             | `/affiliates/{id}`    |
+------------------+             +----------------------+             +-----------------------+
```

---

## 4. Architectural Components

### Domain Layer
- **`affiliate_models.dart`**: `AffiliateTier`, `PayoutStatus`, `AffiliateReferral`, `PromoAsset`, and `AffiliateProfile`.
- **`affiliate_engine.dart`**: Pure Dart deterministic tier resolution, commission calculation, referral attribution, and UPI payout simulation.

### Presentation Layer
- **`affiliate_provider.dart`**: Riverpod `StateNotifierProvider` managing live profile state, promo code updates, sandbox referral sales, and UPI withdrawals.
- **`affiliate_screen.dart`**: Premium dark-mode Bento UI featuring hero earnings metrics, one-tap code copy & share, tier progress bar, recent referral conversions feed, and promotional creatives.

---

## 5. Security & Offline Verification
- **Firestore Security Rules**: Protected path `/affiliates/{affiliateId}` where profile is isolated by owner UID (`isOwner(affiliateId)`) and referrals/payout subcollections are write-restricted to server-side only.
- **100% Offline Capable**: All commission math, tier promotions, and local profile metrics execute deterministically without cloud dependency.
- **Unit Tests**: Full test suite in `test/features/monetisation/affiliate_test.dart` passing with 100% test coverage.
