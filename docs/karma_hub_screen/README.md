# Karma Hub Screen (Gamification & Health Operating System HUD)

## 1. Overview & Architectural Role
The **Karma Hub Screen** is the user-facing command center for the FitKarma gamification engine. It visualizes the user's deterministic Level, Tier status (*Arambh*, *Sadhak*, *Abhyasi*, *Veer*, *Yogi*), active streak multiplier, dynamic badge unlocks across 5 lifestyle pillars, and live activity audit ledger.

---

## 2. Key Screen Components

### 2.1 Hero Tier & Level Progression Card
- Displays the user's active tier badge with level indicator ($L_{\text{current}}$).
- Shows lifetime Karma points ($KP_{\text{life}}$) with high-contrast typography.
- Real-time progress bar computing exact percentage completion and remaining points to the next level:
  $$\text{Progress} = \frac{KP_{\text{life}} - KP_{\text{floor}}}{KP_{\text{ceil}} - KP_{\text{floor}}}$$

### 2.2 Streak & Multiplier Status Grid
- Real-time streak tracking (Current Days vs. Personal Longest).
- Active multiplier pill ($M_{\text{streak}} \in [1.00\times, 2.00\times]$).
- Ratio of unlocked achievements to total milestone badges.

### 2.3 Quick Action Health Loggers
- Interactive action triggers allowing instantaneous logging of:
  - Post-Meal Shatpawali walk ($+50\text{ KP} \times M$)
  - Resistance training workout completion ($+150\text{ KP} \times M$)
  - Macronutrient & protein target adherence ($+100\text{ KP} \times M$)
  - Optimal restorative sleep ($+75\text{ KP} \times M$)

### 2.4 Filterable Badge Showcase
- 5 Gamification Pillar filters:
  - *Metabolic Mastery* (शतपावली व ग्लूकोज नियंत्रण)
  - *Kinematic Excellence* (स्ट्रेंथ व बायोमैकेनिक्स)
  - *Recovery & Circadian* (निद्रा व रिकवरी)
  - *Cultural & Ayurvedic* (दैनिक जीवनशैली व पदोन्नति)
  - *Consistency & Grit* (अखंड संकल्प व स्ट्रीक)
- Unlocked state markers and linear progress indicators for ongoing milestones.

### 2.5 Real-Time Activity Ledger
- Chronological transaction audit trail showcasing action description, applied boost multipliers, and awarded points.

---

## 3. Implementation Details

| Layer | File Path | Responsibilities |
| :--- | :--- | :--- |
| **Presentation Screen** | [`karma_hub_screen.dart`](file:///f:/fitkarma/lib/features/gamification/presentation/karma_hub_screen.dart) | Full Bento UI layout with animated glow effects, filterable badge list, and live transaction feedback. |
| **Riverpod Provider** | [`karma_provider.dart`](file:///f:/fitkarma/lib/features/gamification/presentation/providers/karma_provider.dart) | State management bridging UI actions with mathematical calculations in `karma_engine.dart`. |

---

## 4. Security & Offline Persistence
- Pure Dart state management with offline persistence support.
- Zero network round-trips required for badge progress evaluation and local ledger updates.

---

## 5. Verification
- Validated via `flutter analyze` with 0 issues.
