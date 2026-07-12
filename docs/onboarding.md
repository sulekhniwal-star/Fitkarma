# Fitkarma Local Development Onboarding & SDK Prerequisites

Welcome to the Fitkarma engineering team! This guide details how to configure your local development environment, set up the SQLite/Drift databases, and provision/configure the required third-party SDKs and API keys.

---

## 1. Local Dev Environment Setup

### System Prerequisites
Ensure you have the following frameworks installed on your machine:
*   **Flutter SDK**: `^3.x` (Channel Stable)
*   **Dart SDK**: `^3.x`
*   **IDE**: VS Code (recommended) or Android Studio with Flutter/Dart extensions.
*   **Platform Builds**:
    *   **Android**: Android Studio + SDK Platform Tools 34+
    *   **iOS**: Xcode 15+ (if developing on macOS)

### Core CLI Tool Chains
Activate and install the required global code generators and database helper CLIs:
```bash
# Activate Mason CLI for code scaffolding and generators
dart pub global activate mason_cli

# Run package installation
flutter pub get
```

### Drift Database Code Generation
Fitkarma uses **Drift** + **SQLCipher** for a secure offline-first data layer. Code generation is required to compile table adapters:
```bash
# Execute build_runner to generate drift client models
flutter pub run build_runner build --delete-conflicting-outputs
```
*Note: SQLite local databases reside in your app documents directory (e.g., `fitkarma.db` on mobile targets).*

---

## 2. SDK Configuration & API Keys

To configure cloud integrations, create a `lib/core/config/env.dart` or supply environment values using `--dart-define`.

### 2.1 Groq Cloud API (Multi-Model AI)
Fitkarma's AI Router classifies prompt complexities and maps them to Groq endpoints.

1.  **Obtain Key**: Create an account on the [Groq Console](https://console.groq.com/) and generate an API key.
2.  **Configuration**: Pass the key during builds:
    ```bash
    flutter run --dart-define=GROQ_API_KEY="gsk_your_key_here"
    ```
3.  **Model Mapping Details**:
    *   **Tiny** (Classification / Intent Labeling): `llama3-8b`
    *   **Medium** (Daily Insights generation): `llama3-70b-versatile`
    *   **Large** (Coaching Chats & Evolution Memory): `llama3-70b-full`

### 2.2 Azure (Entra B2C & Azure SQL Database)
Fitkarma uses Azure Entra B2C for user federation and Azure SQL Serverless for remote synchronization.

1.  **Entra B2C Auth**:
    *   Create an Azure AD B2C tenant.
    *   Register your mobile application and extract the **Client ID**, **Tenant Domain**, and **Policy Flow Name** (e.g. `B2C_1_signin_signup`).
    *   Set client parameters:
        ```dart
        const entraClientId = 'your-entra-client-id';
        const entraTenantName = 'your-tenant-name.onmicrosoft.com';
        ```
2.  **Azure SQL Serverless**:
    *   Provision an Azure SQL Serverless database.
    *   Add your local dev IP to the firewall rules in the Azure Portal.
    *   Connect your sync worker endpoint by supplying connection parameters in your Durable Functions settings.

### 2.3 RevenueCat (In-App Subscriptions)
Fitkarma manages premium features using RevenueCat subscription packages.

1.  **Register Entitlements**:
    *   Set up a project on the [RevenueCat Dashboard](https://app.revenuecat.com/).
    *   Configure Store configurations for iOS (App Store Connect shared secret) and Android (Google Play Service Account credentials).
    *   Define an Entitlement named `premium_membership` and bind it to product IDs (e.g. `fitkarma_premium_monthly`).
2.  **Initialize SDK**:
    ```dart
    import 'package:purchases_flutter/purchases_flutter.dart';

    Future<void> initPlatformState() async {
      await Purchases.setLogLevel(LogLevel.debug);
      PurchasesConfiguration configuration = PurchasesConfiguration("public_sdk_key");
      await Purchases.configure(configuration);
    }
    ```

### 2.4 Health Connect (Android) & HealthKit (iOS)
Sync biomarker and activity steps directly from device hardware.

#### Android Health Connect Integration
1.  **Manifest Configurations** (`android/app/src/main/AndroidManifest.xml`):
    *   Declare permissions and intent actions inside the `<queries>` and `<activity>` scopes:
        ```xml
        <queries>
            <package android:name="com.google.android.apps.healthdata" />
        </queries>
        ```
2.  **Permissions Schema**:
    *   Create `res/values/health_permissions.xml` defining queries for Steps, Heart Rate, and Blood Pressure readings.

#### iOS HealthKit Integration
1.  **Entitlements Configuration**:
    *   Open `ios/Runner.xcworkspace` in Xcode.
    *   Navigate to **Signing & Capabilities** -> add **HealthKit**.
    *   Enable **Background Delivery** if background sync is desired.
2.  **Info.plist Keys**:
    *   Specify descriptions explaining why the app requests access:
        ```xml
        <key>NSHealthShareUsageDescription</key>
        <string>Fitkarma accesses your steps and workouts to calculate daily caloric offsets.</string>
        <key>NSHealthUpdateUsageDescription</key>
        <string>Fitkarma writes step goals to track progress milestones.</string>
        ```
