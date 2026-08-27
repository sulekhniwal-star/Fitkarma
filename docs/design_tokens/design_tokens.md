# FitKarma — Design Tokens Specification

## Overview
Defines the visual design tokens for FitKarma v2.0: dark-mode palette, glassmorphism surface layers, typography scales, spacing units, border radii, and spring-physics animation parameters.

---

## 1. Color Palette

| Token | Hex / Value | Purpose |
|---|---|---|
| `AppColors.background` | `#0D0F12` | Primary app canvas |
| `AppColors.surface` | `#161A20` | Base container / card background |
| `AppColors.surfaceElevated` | `#1E232B` | Elevated modal / sheet background |
| `AppColors.glassFill` | `rgba(255,255,255,0.10)` | Glassmorphism surface fill |
| `AppColors.glassBorder` | `rgba(255,255,255,0.15)` | Subtle translucent borders |
| `AppColors.karmaGreen` | `#00E676` | Primary brand accent & optimal readiness |
| `AppColors.focusBlue` | `#00B0FF` | Secondary accent & moderate readiness |
| `AppColors.energyOrange` | `#FF9100` | Energy, workout, and warning accent |
| `AppColors.alertRed` | `#FF5252` | Safety alerts, rest readiness, error states |
| `AppColors.aiPurple` | `#7C4DFF` | AI Coach / Groq synthesis highlights |
| `AppColors.gold` | `#FFD700` | Karma milestones & badges |

---

## 2. Typography

- **Headings & Metrics**: Google Fonts **Outfit** (`displayLarge`, `displayMedium`, `metricHero`, `metricValue`).
- **Body & Labels**: Google Fonts **Inter** (`bodyLarge`, `bodyMedium`, `metricLabel`).

---

## 3. Spacing & Radii

- **Spacing**: 4px baseline scale (`xs: 4`, `sm: 8`, `md: 16`, `lg: 24`, `xl: 32`, `xxl: 48`).
- **Radii**: `sm: 8px`, `md: 16px`, `lg: 24px`, `xl: 32px`, `full: 999px`.

---

## 4. Animation & Spring Physics

- **Durations**: `fast (150ms)`, `normal (250ms)`, `medium (400ms)`, `slow (600ms)`.
- **Curves**: Spring physics with `ElasticOutCurve(0.8)` for responsive ring filling and karma rewards.
