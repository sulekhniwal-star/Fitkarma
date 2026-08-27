# Smart Wearable Comparison Layer (Device Confidence Matrix, Late-Sync Merge Rules)

## 1. Feature Description
Resolves multi-source wearable data conflicts and late-sync collisions across Apple Watch, WHOOP, Oura, Garmin, and Health Connect using a deterministic Device Confidence Matrix and timestamp arbitration rules.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 4 — Health Tracking, §P4 Smart Wearable Comparison Layer)
- **Phase:** Phase 4 — Health Tracking

## 3. Key Files & Responsibilities
- `lib/features/health_tracking/domain/wearable_merge_engine.dart`: Pure Dart mathematical arbitration engine ranking sensor confidence across HRV, Sleep, Steps, and Workout Heart Rate, resolving multi-device collisions and late syncs.
- `lib/features/health_tracking/presentation/wearable_comparison_screen.dart`: Wearable manager screen displaying active authoritative data streams, confidence scores, conflict resolution audits, and connected device hierarchies.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads: `/users/{uid}/wearableDevices/{deviceId}`
  - Writes: `/users/{uid}/settings.wearablePriorities`
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic device tier rankings, confidence scores, and timestamp arbitration logic in pure Dart.
- **AI Logic:** None in core wearable merge engine.

## 6. Deviations from Spec
- None. Fully adheres to Smart Wearable Comparison Layer specifications.
