# Implementation Plan: Onboarding Permissions Screen (§P1-A Step 7)

Finish the core onboarding funnel by implementing the final step: the Health and Notification Permissions screen. This screen enables the application to sync with system-level health data (HealthKit/Health Connect) and deliver critical daily mission alerts, fulfilling a core requirement for Phase 1 and the Master Launch Checklist.

## User Review Required

> [!IMPORTANT]
> The permissions screen will request access to sensitive health data (Steps, Sleep, Heart Rate, HRV). We will use the `health` package for cross-platform integration as specified in §P4-B/C.

> [!NOTE]
> We will add the `permission_handler` package to manage notification permissions and other system-level access, as the `health` package focuses primarily on medical telemetry.

## Proposed Changes

### Core Foundation
- Add `permission_handler` to `pubspec.yaml`.

### Onboarding Feature
#### [NEW] [permissions_controller.dart](file:///F:/fitkarma/lib/features/onboarding/permissions_controller.dart)
- Create a Riverpod Notifier to track the state of Health and Notification permissions.
- Implement logic to request `health` data authorization for:
    - Steps
    - Heart Rate
    - HRV
    - Sleep
    - Active Energy
- Implement logic to request system notification permissions.

#### [NEW] [permissions_screen.dart](file:///F:/fitkarma/lib/features/onboarding/permissions_screen.dart)
- Build the UI according to §P0-A Design Philosophy:
    - Dark mode primary with glassmorphism.
    - Bento grid layout for permission types.
    - High-impact CTAs using `FitButton`.
- Integrate `OnboardingProgressIndicator` for Step 5 of 5.

### Routing
#### [MODIFY] [app_router.dart](file:///F:/fitkarma/lib/core/routing/app_router.dart)
- Replace the `_OnboardingPlaceholderScreen` with the new `PermissionsScreen`.

## Verification Plan

### Automated Tests
- **Widget Test:** `test/permissions_screen_test.dart`
    - Verify all Bento cards and buttons render.
    - Verify tapping "Grant Access" triggers the controller.
- **Unit Test:** `test/permissions_controller_test.dart`
    - Verify permission state updates correctly when granted/denied.

### Manual Verification
- Walk through the onboarding funnel from Welcome to Permissions.
- Verify that the Permissions screen correctly displays Step 5 of 5.
- Verify that clicking "Complete Setup" marks onboarding as finished and redirects to the Dashboard.
