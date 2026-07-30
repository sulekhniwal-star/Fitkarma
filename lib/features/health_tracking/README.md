# Health Tracking Feature (`lib/features/health_tracking/`)

## Purpose
Manages vitals logging (Steps, Sleep, Blood Pressure, Blood Glucose), auto-detection from Health Connect / HealthKit, and visual risk indicators.

## Subdirectories
- **`models/`**: Vitals log models (`BloodPressureLog`, `GlucoseLog`, `StepLog`).
- **`providers/`**: Riverpod state management for vitals history and Health Connect sync.
- **`screens/`**: Interactive `VitalsTrackingScreen` with tabbed vitals logging.
