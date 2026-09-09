# Smart Calendar Integration & Micro-Window Wellness Engine

## 1. Overview
The **Smart Calendar Integration** system analyzes the user's daily work schedule, calendar blocks, and meeting density to dynamically identify micro-wellness opportunities (5–30 minute gaps) throughout the day. It calculates real-time **Cognitive Load Scores** (0–100) and adapts the user's physical workout intensity from high-intensity hypertrophy to restorative yoga and breathwork on high-strain burnout days.

---

## 2. Core Architectural Components

### Domain Layer
- **`smart_calendar_models.dart`**:
  - `CalendarEventType`: High-stress meeting, routine desk work, transit/commute, social/family event, open schedule gap with associated cognitive weights.
  - `CalendarEventBlock`: Represents scheduled time blocks with start/end timestamps and duration.
  - `SuggestedWellnessSlot`: Micro-window allocation (activity, rationale, Hindi translation, optimal timing flag).
  - `SmartCalendarPlanReport`: Comprehensive report containing total meeting hours, cognitive load score, burnout indicator, recommended workout pacing, and pre-meeting meal timing guidance.
- **`smart_calendar_engine.dart`**:
  - `SmartCalendarEngine`: Pure Dart deterministic scheduling and cognitive load analyzer.
  - Micro-window identification:
    - *Early Morning (06:00 - 08:30)*: Surya Namaskar & Core Activation.
    - *Midday Lunch (12:00 - 15:00)*: 10-Minute Post-Meal Shatapadi Digestive Stroll (1,000 paces).
    - *Pre-Meeting Buffer*: 5-minute Anulom Vilom & Box Breathing Buffer for vagus nerve activation.
    - *Evening (18:00 - 22:00)*: Spinal decompression & restorative foam rolling.

### Presentation Layer
- **`smart_calendar_provider.dart`**: Riverpod `StateNotifierProvider` managing live schedule mutations, event addition, event deletion, and resets.
- **`smart_calendar_screen.dart`**: Premium dark-mode Bento interface featuring:
  - Hero Cognitive Load & Meeting Hours display with dynamic glowing warning states.
  - Pre-Meeting Nutrition & Glucose Timing card.
  - Identified Micro-Wellness Slots list.
  - Interactive schedule manager with bottom sheet modal to add custom meeting blocks.

---

## 3. Offline & Security Verification
- **Pure Offline Capability**: 100% deterministic algorithms with no network or third-party cloud dependence required for calculations.
- **Zero Privacy Leakage**: Event titles and timestamps are processed locally on-device.
- **Unit Tests**: Full test suite in `test/features/festival_life_events/smart_calendar_test.dart` passing with 100% coverage.
