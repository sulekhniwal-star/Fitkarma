# Monetisation & Creator Marketplace Engine (FitKarma Phase 13)

FitKarma's Monetisation architecture powers multi-tiered subscription entitlements, a marketplace for certified Indian health coaches, and a Yogi affiliate referral network.

---

## Key Capabilities

1. **Subscription Tiers & Server-Side Entitlements (`EntitlementEngine`)**:
   - **Yogi Free**: Ad-supported daily missions, activity rings, basic Dosha profiling, Desi workouts, and squad view.
   - **FitKarma Pro (₹199/mo or ₹1,999/yr)**: Unlimited AI Adaptive Coaching (with Sharma Ji roasts), real-time CGM spike telemetry, biological cellular age estimation, 1-click clinical doctor dossiers, visual body composition analytics, and Shaadi/travel modes (Ad-free).
   - **FitKarma Elite (₹999/mo or ₹7,999/yr)**: All Pro features + monthly 1-on-1 consultations with verified functional medicine specialists, lab review, and priority WhatsApp/voice logging.
   - **Corporate & Insurer Tier**: SSO and enterprise wellness dashboard integration.

2. **Verified Indian Coach Marketplace (`CoachMarketplaceEngine`)**:
   - Filter coaches by specialized clinical domains: PCOS remission, Type 2 diabetes reversal, Ayurvedic strength (Akhada Vyayam), postpartum pelvic floor recovery, and cardiometabolic health.
   - Multi-lingual filtering across vernacular Indian languages (Hindi, Tamil, Telugu, Punjabi, Kannada, Malayalam).
   - In-app booking and consultation scheduling with local currency pricing (INR ₹).

3. **Creator & Yogi Affiliate Program (`AffiliateEngine`)**:
   - Personalized `YOGI-XXXX` referral codes.
   - Dual incentive model: Karma point bonuses + cash commissions (UPI payout) on Pro and Elite tier conversions.

4. **Offline-First Persistence & Synchronization**:
   - Local Drift tables: `LocalEntitlements`, `LocalCoachProfiles`, `LocalCoachBookings`, `LocalAffiliateReferrals`.
   - Outbox synchronization via `OutboxSyncWorker`.
   - Supabase schema: `entitlements` (server-role write only), `coach_profiles` (public read), `coach_bookings` (RLS protected), `affiliate_referrals` (RLS protected).
