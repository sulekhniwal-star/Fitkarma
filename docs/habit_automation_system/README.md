# Habit Automation System (Circadian Behavioral Loops)

## 1. Overview & Architectural Role
The **Habit Automation System** transforms passive wellness tracking into an active, context-aware habit stacking engine anchored in Indian circadian rhythms (*Dinacharya*). By coupling behavioral science (Cue $\rightarrow$ Routine $\rightarrow$ Reward) with automatic multi-sensor triggers (Wearable step detection, meal scanner, workout completion), habits transition from conscious effort to automatic reflexes.

---

## 2. Mathematical Formulations & Behavioral Science

### 2.1 Habit Strength Index (HSI)
The **Habit Strength Index ($HSI \in [0.0, 100.0]$)** evaluates behavioral retention using an exponential recency decay model ($\lambda = 0.05$):
$$HSI = \frac{\sum_{i=0}^{N-1} \text{Completion}_i \times e^{-\lambda (N - 1 - i)}}{\sum_{i=0}^{N-1} e^{-\lambda (N - 1 - i)}} \times 100$$
where:
- $\text{Completion}_i = 1$ if the habit was fulfilled on day $i$, else $0$.
- $N = 30$ days (rolling retention window).

### 2.2 Automaticity Tiers
Based on the computed $HSI$:
- **Formation Phase ($HSI < 40$)**: Initial habit establishment requiring conscious cognitive willpower.
- **Reinforcement Phase ($40 \le HSI < 75$)**: Emerging routine with established neural association.
- **Automatic Reflex ($HSI \ge 75$)**: Fully automated behavioral reflex with negligible friction.

### 2.3 Circadian Anchor Time-Slots
1. **Pratah Kal (06:00 – 09:00)**: Ushapan, Morning sunlight, and Pranayama.
2. **Madhyahan (12:00 – 15:00)**: Protein-dense lunch and post-meal 500-step Shatpawali.
3. **Sandhya Kal (17:00 – 20:00)**: Resistance training and athletic movement.
4. **Ratri Charya (20:00 – 23:00)**: Post-dinner 1000-step Shatpawali and 45m digital curfew.

---

## 3. Implementation Details

| Layer | File Path | Responsibilities |
| :--- | :--- | :--- |
| **Domain Models** | [`habit_models.dart`](file:///f:/fitkarma/lib/features/gamification/domain/habit_models.dart) | Data models for `Habit`, `HabitTimeSlot`, `HabitTriggerSource`, `HabitAutomaticityTier`, and `HabitDailySummary`. |
| **Domain Engine** | [`habit_automation_engine.dart`](file:///f:/fitkarma/lib/features/gamification/domain/habit_automation_engine.dart) | Pure Dart calculation of $HSI$, automaticity tier classification, toggle state transitions, and summary metrics. |
| **Riverpod State** | [`habit_provider.dart`](file:///f:/fitkarma/lib/features/gamification/presentation/providers/habit_provider.dart) | Manages daily habit state and triggers dynamic Karma points distribution upon habit completion. |
| **Presentation Screen** | [`habit_automation_screen.dart`](file:///f:/fitkarma/lib/features/gamification/presentation/habit_automation_screen.dart) | Bento UI with time-slot filters, interactive check cards, Cue/Routine breakdowns, and strength indexes. |

---

## 4. Security & Offline Persistence
- **Zero Cloud Latency**: Habit state and HSI calculations run deterministically on-device without cloud round-trips.
- **Firestore Security Rules**: User habit ledgers are partitioned under `/users/{userId}/**` with strict owner-only access.

---

## 5. Verification
- Analyzed via `flutter analyze` with 0 warnings or errors.
- Offline verified with instantaneous state updates.
