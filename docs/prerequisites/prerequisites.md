# FitKarma — Prerequisites & Environment Setup Guide

## 1. Core Requirements

- **Flutter SDK**: 3.x+ (Dart 3.x+)
- **Node.js**: v18+ (v20+ recommended for Firebase Functions v2)
- **Firebase CLI**: `firebase-tools` (`npm install -g firebase-tools`)

---

## 2. Setup Steps

### 2.1 Dependencies Resolution
```bash
flutter pub get
```

### 2.2 Cloud Functions Setup
```bash
cd functions
npm install
```

### 2.3 Local Firebase Emulators
To launch local Firestore, Auth, Storage, and Cloud Functions emulators:
```bash
firebase emulators:start
```

### 2.4 Secrets Configuration (Cloud Functions)
```bash
firebase functions:secrets:set GROQ_API_KEY
firebase functions:secrets:set REVENUECAT_WEBHOOK_SECRET
```

---

## 3. Bootstrap Architecture (`AppBootstrap`)

The application startup lifecycle is governed by `lib/core/bootstrap/app_bootstrap.dart`:
1. `WidgetsFlutterBinding.ensureInitialized()`: Native engine binding.
2. `SystemChrome`: Status and navigation bar translucent styling for immersive dark mode.
3. `LocalStorageService`: Hive local cache box initialization (`drafts`, `active_workout`).
4. `Firebase.initializeApp()`: Safe cloud backend bootstrap with offline resilience.
5. Global Error Traps: `FlutterError.onError` and `PlatformDispatcher.instance.onError`.
