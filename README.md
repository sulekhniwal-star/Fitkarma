# FitKarma

India's intelligent health operating system — an AI-adaptive fitness, nutrition, and wellness app built for the Indian market.

> Full product/architecture spec: [`FitKarma_Documentation_v2.md`](./FitKarma_Documentation_v2.md)
> Build workflow for AI-assisted development: [`SKILL.md`](./SKILL.md)
> Work order / task list: [`TODO.md`](./TODO.md)

## Status

Fresh rebuild — v1.0 (Cloudflare D1/Workers/Drift) has been retired and deleted. This is a from-scratch build on Flutter + Firebase, starting at Phase 0.

## Tech Stack

| Layer | Choice |
|---|---|
| Frontend language | Dart |
| Frontend framework | Flutter 3.x (Android + iOS, single codebase) |
| State management | Riverpod 2.x |
| UI system | Material Design + Cupertino + custom animation layer |
| Local storage | Firestore offline persistence + Hive (local-only cache) |
| Cloud database | Firebase Firestore |
| Backend compute | Firebase Cloud Functions (Node.js / JavaScript) |
| Auth | Firebase Authentication |
| File storage | Firebase Cloud Storage |
| Push notifications | Firebase Cloud Messaging |
| AI | Groq (multi-model routing), called server-side only |
| Payments | RevenueCat |
| API pattern | REST — Firebase Callable Functions + HTTPS webhooks |
| Tooling | Git/GitHub, VS Code, Postman |

## Project Structure

```
fitkarma/
├── lib/
│   ├── features/           # one folder per feature (see TODO.md phases)
│   │   └── <feature_name>/
│   │       ├── data/        # repositories, Firestore access
│   │       ├── presentation/# screens, widgets
│   │       ├── providers/   # Riverpod state
│   │       └── README.md    # required — see SKILL.md §3
│   ├── shared/
│   │   └── widgets/         # BentoCard, ActivityRings, GlowingMetric, BilingualLabel
│   └── main.dart
├── functions/                # Firebase Cloud Functions (JavaScript)
│   ├── healthOS/             # Daily Intelligence Package orchestration
│   ├── aiRouter/             # Groq multi-model routing
│   └── webhooks/             # RevenueCat, WhatsApp Business, etc.
├── firestore.rules
├── storage.rules
├── FitKarma_Documentation_v2.md
├── SKILL.md
├── TODO.md
└── README.md
```

## Getting Started

1. Install Flutter 3.x and the Firebase CLI.
2. `flutterfire configure` to connect the project to a Firebase project (Firestore, Auth, Storage, Functions, FCM enabled).
3. `cd functions && npm install` for Cloud Functions dependencies.
4. Set Groq API key and RevenueCat webhook secret via `firebase functions:secrets:set`.
5. `flutter run` for local development; `firebase emulators:start` for local Firestore/Functions testing.

## Contributing / Working on this repo

Read `SKILL.md` before starting any feature — it defines the mandatory workflow, including that every completed feature needs its own `README.md`. `TODO.md` is the single source of truth for what to build next; work top-to-bottom by phase.

## License

Proprietary — all rights reserved.
