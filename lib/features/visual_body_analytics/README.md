# Visual Body Analytics Operating System (`lib/features/visual_body_analytics`)

## Overview
The **Visual Body Analytics** module delivers hardware-free, camera-assisted, and anthropometric body composition tracking designed specifically for the Asian-Indian phenotype. It replaces inaccurate bioimpedance consumer scales with the clinical U.S. Navy standard formula, tracking Fat-Free Mass Index (FFMI), Waist-to-Height Ratio (WHtR), and encrypted progress photos.

---

## Core Engines & Components

### 1. `BodyCompositionEngine`
- **Location**: `lib/features/visual_body_analytics/domain/services/body_composition_engine.dart`
- **Responsibilities**:
  - Computes Body Fat % using Male and Female U.S. Navy Anthropometric algorithms.
  - Calculates Waist-to-Height Ratio (WHtR): Central adiposity warning triggered when $\text{WHtR} \ge 0.50$.
  - Normalizes Fat-Free Mass Index (FFMI) to a $1.8\text{m}$ standard frame.
  - Computes exact Lean Muscle Mass ($\text{kg}$) and Fat Mass ($\text{kg}$).

### 2. `VisualComparisonEngine`
- **Location**: `lib/features/visual_body_analytics/domain/services/visual_comparison_engine.dart`
- **Responsibilities**:
  - Compares baseline vs. latest progress photo entries across Front, Side, and Back poses.
  - Computes weight, body fat %, and waist circumference deltas across specific day spans.

### 3. `BodyAnalyticsRepository`
- **Location**: `lib/features/visual_body_analytics/data/body_analytics_repository.dart`
- **Drift Tables**:
  - `LocalProgressPhotos`
  - `LocalBodyCompositionSnapshots`
- **Outbox Sync**: Queues offline mutations to Supabase with Row Level Security.

### 4. `BodyAnalyticsScreen`
- **Location**: `lib/features/visual_body_analytics/presentation/screens/body_analytics_screen.dart`
- **Features**:
  - Estimated Body Fat % & Lean Muscle Mass Hero Bento Card.
  - Waist-to-Height Ratio gauge and FFMI muscularity tracker.
  - Bottom-sheet anthropometric calculator (Neck, Waist, Hip, Weight).
  - Encrypted progress photo comparison view.

---

## Verification
- Unit Tests: `test/visual_body_analytics_test.dart`
- Supabase Migration: `supabase/migrations/20260912000011_phase11_body_analytics_schema.sql`
