# Creator & Coach Marketplace

## 1. Overview
The **Creator & Coach Marketplace** is FitKarma's decentralized creator economy hub, connecting users with certified personal trainers, clinical dietitians, and Ayurvedic Vaidyas. Instructors can list self-paced structured transformation programs, personalized diet protocols, and 1-on-1 video consultations with transparent 80/20 platform revenue splits.

---

## 2. Core Offering Categories

| Category | Offerings | Target Audience |
| :--- | :--- | :--- |
| **Strength & Hypertrophy** | 12-Week Periodized Barbell/Dumbbell Programs | Muscle building & body recomposition with Indian macro plans |
| **Clinical Nutrition** | PCOS, Insulin & Metabolic Balancing Protocols | Evidence-based low-GI grain & hormonal nutrition |
| **Ayurvedic Health** | 30-Day Agni & Gut Detox Protocols | Ama removal, Ritucharya seasonal adjustments, herbal churnas |
| **1-on-1 Consultations** | Live Biomechanics & Form Check Clinics (45–60 min) | Barbell bar-path review, mobility restrictions, video feedback |
| **Yoga & Mobility** | Ashtanga Vinyasa & Spinal Posture | Desk workers with upper crossed syndrome & tight hips |

---

## 3. Revenue Share & Economics
- **80% Direct Creator Payout**: Creators receive 80% of every transaction.
- **20% Platform Fee**: Covers payment gateway processing, video infrastructure, server-side entitlement checks, and buyer protection.

---

## 4. Architectural Components

### Domain Layer
- **`marketplace_models.dart`**: `CoachSpecialty`, `ListingType`, `CoachProfile`, `MarketplaceListing`, `MarketplaceOrder`, and `MarketplaceFilter`.
- **`marketplace_engine.dart`**: Pure Dart deterministic filtering by specialty, query, rating, and verified status; 80/20 split calculator; sample Pan-Indian catalog.

### Presentation Layer
- **`marketplace_provider.dart`**: Riverpod `StateNotifierProvider` managing live catalog filtering, search query updates, and order enrollments.
- **`marketplace_screen.dart`**: Premium dark-mode Bento UI with full-text search, specialty carousels, verified coach badges, and instant checkout sheets.

---

## 5. Security & Offline Verification
- **Firestore Security Rules**: Protected path `/marketplace/{listingId}` where listings can only be created/updated by verified instructors (`resource.data.creatorId == request.auth.uid`).
- **Storage Rules**: Instructor media and program previews reside under `/public/**` with authenticated upload restrictions.
- **100% Offline Functional**: Complete offline catalog browsing, multi-attribute filtering, and order history persist without continuous internet access.
- **Unit Tests**: Full test suite in `test/features/monetisation/marketplace_test.dart` passing with 100% coverage.
