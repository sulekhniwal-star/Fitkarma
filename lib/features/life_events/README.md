# Life Events & Festival Intelligence Engine (FitKarma Phase 12)

FitKarma's Life Events feature integrates culturally calibrated health protocols tailored for Indian life milestones, fasts, celebrations, and business travel.

---

## Key Capabilities

1. **Festival Nutrition & Fasting Protocols (`FestivalIntelligenceEngine`)**:
   - **Navratri / Ekadashi**: Fast-compatible macro guidance (Kuttu, Singhara, Makhana, Paneer), zero dehydration strategy.
   - **Ramadan**: Suhoor complex carb loading and gentle Iftar refuel strategies to prevent reactive hypoglycemia.
   - **Diwali / Holi**: Festive feast damage control, pre-buffet satiety shields, and sweet tasting portion limits.
   - **Karwa Chauth**: Pre-dawn hydration loading and post-moonrise gentle digestion protocol.

2. **Wedding Transformation Mode (`WeddingTransformationEngine`)**:
   - **Countdown Peaking Protocol**: 12-week progression from foundation metabolic priming to peak week water/sodium manipulation.
   - **Garment-Fit Optimization**: Target waist-to-chest ratios specifically tailored for Sabyasachi lehengas, sherwanis, and heavy Indian ethnic wear.
   - **Bloat & Water Retention Protocols**: Potassium-rich, low-sodium tapering during the final 7 days to enhance muscle fullness and reduce abdominal bloating.

3. **Sharma Ji AI Accountability Roast (`AIRoastEngine`)**:
   - Humorous, culturally relatable roast messages delivered by the AI Coach for missed workouts and cheat splurges.
   - Configurable severity: Mild, Spicy, Savage.
   - Every roast concludes with an actionable redemption mission (e.g. 5,000 steps before midnight or 50 Desi Dand).

4. **Travel & Hotel Mode (`TravelIntelligenceEngine`)**:
   - Zero-equipment hotel room workouts (HIIT, Surya Namaskar, isometric holds).
   - Buffet shields, Indian business dinner navigation, and gut-microbiome defense.

5. **Offline-First Persistence & Synchronization**:
   - Local Drift tables: `LocalActiveLifeEvents`, `LocalWeddingPlans`.
   - Automatic background sync via `OutboxSyncWorker`.
   - Supabase schema: `active_life_events`, `wedding_transformation_plans` with RLS policies.
