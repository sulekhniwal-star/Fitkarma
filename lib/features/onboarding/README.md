# Onboarding Feature (`lib/features/onboarding/`)

## Purpose
Manages the multi-step onboarding journey, profile registration, metabolic baseline calculation (BMI, BMR, TDEE), Ayurvedic Dosha assessment, dietary preference configuration, and initial health data permissions.

## Subdirectories
- **`models/`**: `UserProfile` data models, metabolic equations, and Dosha evaluation logic.
- **`providers/`**: Riverpod state management for onboarding step progress and draft user profile state.
- **`screens/`**: Interactive step screens (Welcome, Biometrics, Goal Selection, Dietary Preferences, Dosha Quiz, Program Blueprint, Permissions).
