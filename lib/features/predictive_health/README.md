# Predictive Health Feature (`lib/features/predictive_health/`)

## Purpose
Manages Biological Age estimation, Continuous Glucose Monitor (CGM) spike detection, Medication tracking with Drug-Nutrient / Drug-Workout interaction checks, and passcode-protected Doctor Sharing PDF export.

## Subdirectories
- **`models/`**: `MedicationLog`, `DrugInteractionWarning`, and `CgmSpikeEvent` data models.
- **`providers/`**: Riverpod state management for biological age, CGM streams, and passcode generator.
- **`screens/`**: Interactive `PredictiveHealthScreen` displaying biological age, CGM alerts, and doctor sharing portal.
