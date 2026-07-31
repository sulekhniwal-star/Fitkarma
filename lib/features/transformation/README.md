# Transformation Feature (`lib/features/transformation/`)

## Purpose
Manages 90-day weight trajectory forecasting (ranges), 3-tier relapse intervention nudges, monthly transformation memory snapshots, and biometric-encrypted progress photo storage.

## Subdirectories
- **`models/`**: `TransformationMemory` and `ProgressPhotoEntry` data models.
- **`providers/`**: Riverpod state management for 90-day weight forecasts and relapse intervention triggers.
- **`screens/`**: Interactive `TransformationDashboardScreen` with weight range charts and encrypted photo vault.
