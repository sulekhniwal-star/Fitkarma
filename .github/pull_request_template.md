## Summary
Brief description of the changes introduced by this PR.

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Phase 10 Clinical / Predictive feature update

## Clinical Copy Change Checklist (required for PRs touching §P10-I, §P10-H, §P10-J)
- [ ] `ClinicalCopyLinter` passes with zero violations (`dart run scripts/verify_clinical_copy.dart`)
- [ ] Non-diagnostic disclaimer (`NonDiagnosticShieldBanner`) is present and unmodified on affected screens
- [ ] Change reviewed by compliance / legal sign-off role for this release (§P10-M)

## Verification
- [ ] `flutter test` passed cleanly locally
- [ ] Static analysis (`flutter analyze`) clean
