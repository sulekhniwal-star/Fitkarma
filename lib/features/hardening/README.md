# Hardening Feature (`lib/features/hardening/`)

## Purpose
Manages performance tier optimizations (`DeviceTier.low`), Sentry PII stripping, Dead Letter Queue (DLQ) sync failure alert banners, and DPDP Act Privacy Policy compliance.

## Subdirectories
- **`models/`**: Hardening configuration data models.
- **`providers/`**: Riverpod state management for DLQ sync failure counters and performance settings.
- **`screens/`**: Interactive `HardeningVerificationScreen` displaying DLQ banners and privacy policies.
