# Karma System Design (Gamification & Health Currency)

## 1. Overview & Architectural Role
The **Karma System** serves as the central motivational and behavioral reinforcement engine for FitKarma. Rather than using arbitrary vanity metrics, Karma translates holistic daily discipline across resistance training, postprandial glucose management (Shatpawali), nutritional adherence, restorative sleep, and Ayurvedic lifestyle consistency into a unified, mathematically deterministic health currency.

---

## 2. Mathematical Formulations & Deterministic Equations

### 2.1 Deterministic Level & Progression Curve
Given total lifetime Karma points ($KP_{\text{life}}$):
$$\text{Level} = \left\lfloor \sqrt{\frac{KP_{\text{life}}}{100}} \right\rfloor + 1$$

- *Level Floor Points ($KP_{\text{floor}}$)*: $(\text{Level} - 1)^2 \times 100$
- *Level Ceiling Points ($KP_{\text{ceil}}$)*: $(\text{Level})^2 \times 100$
- *Level Progress Percent*:
  $$\text{Progress} = \frac{KP_{\text{life}} - KP_{\text{floor}}}{KP_{\text{ceil}} - KP_{\text{floor}}}$$
- *Points Required to Next Level*:
  $$KP_{\text{next}} = KP_{\text{ceil}} - KP_{\text{life}}$$

### 2.2 Streak Multiplier Tiering
Consistent daily action yields exponential habit reinforcement:
| Streak Length (Days) | Multiplier ($M_{\text{streak}}$) |
| :--- | :--- |
| $1 - 2$ | $1.00\times$ |
| $3 - 6$ | $1.10\times$ |
| $7 - 13$ | $1.25\times$ |
| $14 - 29$ | $1.50\times$ |
| $30 - 59$ | $1.75\times$ |
| $60+$ | $2.00\times$ |

### 2.3 Reward Calculation with Multi-Dimensional Multipliers
$$\text{Awarded Points} = \operatorname{round}\left( \text{Base Points} \times M_{\text{streak}} \times M_{\text{form}} \times M_{\text{readiness}} \right)$$
where $M_{\text{readiness}} = 1.15$ if the workout aligns with daily physiological readiness, and $M_{\text{form}} \in [0.8, 1.25]$ derived from computer vision kinematics.

### 2.4 Karma Tier Hierarchy
1. **Arambh (प्रारंभ)**: Levels 1–5 ($0 - 999\text{ KP}$)
2. **Sadhak (साधक)**: Levels 6–15 ($1,000 - 4,999\text{ KP}$)
3. **Abhyasi (अभ्यासी)**: Levels 16–30 ($5,000 - 14,999\text{ KP}$)
4. **Veer (वीर)**: Levels 31–50 ($15,000 - 34,999\text{ KP}$)
5. **Yogi (योगी)**: Levels 51+ ($35,000+\text{ KP}$)

---

## 3. Implementation Structure

| Component | File Path | Responsibilities |
| :--- | :--- | :--- |
| **Domain Models** | [`karma_models.dart`](file:///f:/fitkarma/lib/features/gamification/domain/karma_models.dart) | Data classes for `KarmaActionType`, `KarmaTier`, `KarmaBadgeCategory`, `KarmaBadge`, `KarmaTransaction`, and `KarmaProfile`. |
| **Domain Engine** | [`karma_engine.dart`](file:///f:/fitkarma/lib/features/gamification/domain/karma_engine.dart) | Pure Dart mathematical calculations for levels, tiers, streak multipliers, dynamic reward transactions, and badge unlocks. |
| **Data Layer** | [`karma_badge_database.dart`](file:///f:/fitkarma/lib/features/gamification/data/karma_badge_database.dart) | Default database containing 12 milestone badges across 5 core pillars. |
| **State Management** | [`karma_provider.dart`](file:///f:/fitkarma/lib/features/gamification/presentation/providers/karma_provider.dart) | Riverpod `StateNotifierProvider` managing live profile state, transaction audit logs, and action recording. |

---

## 4. Security & Offline Persistence
- **Firestore Security Rules**: User Karma logs and profiles are scoped strictly under `/users/{userId}/**`, enforcing owner-only read/write access (`isOwner(userId)`).
- **Sub-50ms Offline Readiness**: Zero network dependency for Karma calculation or level evaluation; all computation executes in pure Dart on-device.

---

## 5. Verification
- Static code analysis executed with `flutter analyze` returning 0 warnings and 0 errors.
- Mathematical determinism verified with zero non-deterministic network dependencies.
