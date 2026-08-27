# FitKarma — Shared Foundation Widgets Specification

## Overview
This document specifies the four foundational UI building blocks in FitKarma: `BentoCard`, `ActivityRings`, `GlowingMetric`, and `BilingualLabel`.

---

## 1. BentoCard (`bento_card.dart`)
- **Purpose**: Core structural container for dashboard metric cards, mission items, and health modules.
- **Features**:
  - Translucent glassmorphism surface with `BackdropFilter` (10px blur).
  - Ambient glow shadow option (`hasGlow`, `glowColor`) for readiness highlights.
  - Interactive tactile spring feedback (scale down to 0.98 on press down, bounce back on release).

---

## 2. ActivityRings (`activity_rings.dart`)
- **Purpose**: Visualizes multi-dimensional daily progress (Calories, Active Minutes, Hydration/Readiness).
- **Features**:
  - Multi-concentric custom painted arcs with rounded caps (`StrokeCap.round`).
  - Smooth spring animation curves (`Curves.easeOutBack`).
  - Configurable center widget slot (e.g. icon or readiness score number).

---

## 3. GlowingMetric (`glowing_metric.dart`)
- **Purpose**: Displays numerical health statistics with ambient text glow, unit suffixes, and directional trends.
- **Features**:
  - Hero mode (`metricHero` 48pt) vs standard mode (`metricValue` 32pt).
  - Neon shadow glow matched to metric context (e.g. Karma Green, Focus Blue, Alert Red).
  - Directional trend arrows (`up`, `down`, `neutral`) with status copy.

---

## 4. BilingualLabel (`bilingual_label.dart`)
- **Purpose**: Displays bilingual text pairings (English + Indic regional languages) to power the India Growth & Accessibility layer.
- **Features**:
  - `stacked` layout (English header + regional subtitle) or `inline` layout.
  - Subdued regional text styling for balanced visual hierarchy.
