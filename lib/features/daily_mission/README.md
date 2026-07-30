# Daily Mission & Readiness Feature (`lib/features/daily_mission/`)

## Purpose
Manages the Daily Briefing dashboard, Readiness Score visualization, 3-question Morning Ritual check-in, Daily Strain tracking (0–21), and Recovery Prescriptions.

## Subdirectories
- **`models/`**: Data structures for Morning Check-in, Recovery Prescriptions, and Daily Briefing State.
- **`providers/`**: Riverpod state management for daily readiness calculations, strain scores, and check-in completion.
- **`screens/`**: Interactive `DailyBriefingScreen` featuring the Hero Readiness Score Ring and morning check-in modal.
