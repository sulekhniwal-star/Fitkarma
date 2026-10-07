# FitKarma — Hydration Tracker Feature (`lib/features/hydration`)

## Overview
The Hydration Tracker addresses a critical everyday health need in the Indian context: extreme summer temperatures (40°C+ heatwaves), high spice intake, and hydration from traditional Indian drinks (Nimbu Pani, Coconut Water, Buttermilk/Chaas, and Chai).

## Architecture & Components
- **Domain Models (`hydration_models.dart`)**:
  - `HydrationLog`: Individual log record with timestamp, volume in ml, and source (`water`, `coconutWater`, `nimbuPani`, `buttermilk`, `chai`, `other`).
  - `HydrationGoalEngine`: Dynamically computes recommended daily intake based on body weight, ambient temperature (°C), local AQI, and user workout activity.
- **State Management (`hydration_provider.dart`)**:
  - `HydrationNotifier` (Riverpod `NotifierProvider`): Manages daily consumption, goal progress, quick logging, and undo operations.
- **User Interface (`hydration_tracker_screen.dart` & `HealthOSHomeScreen`)**:
  - Home Dashboard Bento card with live progress bar and 1-tap quick buttons (+250ml glass, +500ml bottle).
  - Dedicated screen featuring an animated water drop visualizer, historical daily logs, Indian beverage quick-pickers, and seasonal hydration guidance tips.
