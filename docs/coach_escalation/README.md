# Health Coach Escalation Layer (Elite Tier — Human Coach Handoff)

## 1. Feature Description
Enables Elite subscribers to seamlessly escalate complex questions, medical/injury boundaries, or contest periodization to certified human sports coaches, automatically transmitting a structured 14-day biometric handover dossier.

## 2. Spec Reference
- **Specification:** `FitKarma_Documentation.md` (Phase 3 — AI Adaptive Coach, §P3 Health Coach Escalation Layer)
- **Phase:** Phase 3 — AI Adaptive Coach

## 3. Key Files & Responsibilities
- `lib/features/ai_coach/domain/coach_escalation.dart`: Domain entities defining escalation reasons (`medicalBoundary`, `advancedContestPrep`, `userRequested`), ticket status lifecycle (`pendingReview`, `assigned`, `completed`), and automated `CoachHandoverDossier` formatting.
- `lib/features/ai_coach/data/coach_escalation_repository.dart`: Firestore repository persisting escalation tickets under user profiles.
- `lib/features/ai_coach/presentation/coach_escalation_screen.dart`: Premium escalation interface with Elite tier badge, reason selector, biometric dossier preview, question input, and submission timeline.

## 4. Firestore Collections & Fields
- **Data paths:**
  - Reads/Writes: `/users/{uid}/coachEscalations/{ticketId}`
  - Fields: `reason`, `status`, `dossier` (`userName`, `age`, `sex`, `weightKg`, `heightCm`, `bmi`, `primaryGoal`, `dosha`, `readinessScore`, `rolling14DayHrvMs`, `averageSleepHours`), `assignedCoachName`, `coachResponseNotes`, `createdAt`.
- **Security rules:** Nested under `/users/{userId}/**` with strict authenticated owner validation (`request.auth.uid == userId`).

## 5. Deterministic vs. AI Logic Split
- **Deterministic:** 100% deterministic biometric dossier assembly, escalation validation, and ticket status progression in pure Dart.
- **AI Logic:** None; this feature explicitly routes user requests to certified human practitioners.

## 6. Deviations from Spec
- None. Fully adheres to Health Coach Escalation Layer specifications.
