# Premium Feature (`lib/features/premium/`)

## Purpose
Manages RevenueCat billing integration, App Store & Google Play Store product IDs (`fitkarma_pro_monthly`, `fitkarma_pro_yearly`), 7-day free trials, and bottom-sheet Paywall UI.

## Subdirectories
- **`models/`**: `SubscriptionPackage` and `EntitlementState` data models.
- **`providers/`**: Riverpod state management for active subscription entitlements.
- **`screens/`**: Interactive `PaywallBottomSheet` with mandatory "Continue Free" option.
