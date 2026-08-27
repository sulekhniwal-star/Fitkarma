# FitKarma — Project Structure Specification

## Overview
This document defines the complete directory and file layout of FitKarma v2.0 across the Flutter client, Firebase Cloud Functions backend, Firebase rules, local persistence, and shared foundation components.

---

## Directory Hierarchy

```
fitkarma/
├── .agent/
│   └── skills/
│       └── SKILL.md                 # Mandatory AI operating manual & workflow
├── assets/
│   ├── icons/                       # SVG and raster UI icons
│   └── images/                      # Illustrations, brand marks
├── docs/                            # Architectural documentation
│   ├── design_philosophy/           # Design philosophy & anti-patterns spec + README
│   └── project_structure/           # Project structure spec + README
├── functions/                       # Firebase Cloud Functions (Node.js)
│   ├── aiRouter/                    # Groq multi-model routing logic
│   ├── healthOS/                    # Health OS Brain / DIP orchestrator
│   ├── webhooks/                    # RevenueCat & WhatsApp webhook receivers
│   ├── index.js                     # Root Cloud Functions entry & export point
│   └── package.json                 # Node dependencies (firebase-admin, groq-sdk)
├── lib/
│   ├── core/                        # App-wide utilities, constants, exceptions
│   │   └── constants/
│   │       └── app_constants.dart
│   ├── features/                    # Feature-first domain modules (Phase 0 -> Phase 16)
│   │   └── <feature_name>/
│   │       ├── data/                # Repositories & Firestore services
│   │       ├── presentation/        # Screens & UI widgets
│   │       ├── providers/           # Riverpod state notifiers
│   │       └── README.md            # Required per-feature documentation (SKILL.md §3)
│   ├── shared/                      # Reusable components across features
│   │   ├── theme/                   # AppTheme, design tokens, color palette
│   │   └── widgets/                 # BentoCard, ActivityRings, GlowingMetric, BilingualLabel
│   └── main.dart                    # App initialization with Riverpod ProviderScope
├── test/                            # Unit, widget, and golden tests
├── analysis_options.yaml            # Strict Dart lint rules
├── firebase.json                    # Firebase project & local emulators configuration
├── firestore.rules                  # Firestore security rules with per-user data isolation
├── storage.rules                    # Cloud Storage security rules with owner access checks
├── pubspec.yaml                     # Locked Flutter dependencies
├── FitKarma_Documentation.md        # Master product & architecture specification
├── TODO.md                          # Phase-by-phase task tracking command list
└── README.md                        # Project landing & developer setup
```

---

## Architectural Rules for Modules

1. **Feature Module Encapsulation (`lib/features/<feature>/`)**:
   - Each feature encapsulates its own `data/`, `presentation/`, and `providers/`.
   - Features do not cross-import another feature's internal presentation widgets. Shared widgets reside in `lib/shared/widgets/`.

2. **Data Layer Contract**:
   - Direct Firestore interactions happen *only* inside repository classes under `data/`.
   - Presentation widgets watch Riverpod providers to receive immutable state models.

3. **Backend Separation (`functions/`)**:
   - Business logic requiring secret keys or AI model synthesis is housed under `functions/`.
   - Client calls these via `FirebaseFunctions.instance.httpsCallable()`.
