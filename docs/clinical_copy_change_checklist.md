# Clinical Copy Change Checklist & Pre-Ship Legal Review Gate

> **Mandatory PR Template & CI Requirement (§P10-M)**  
> Any Pull Request or code change touching **§P10-H (CGM Sync)**, **§P10-I (Medication Tracker)**, or **§P10-J (Doctor Sharing Portal)** MUST include and complete this checklist prior to release.

---

### Pre-Ship Compliance Checklist

- [ ] **Automated Directive-Language Linter**: `ClinicalCopyLinter` passes with zero violations (`flutter test test/core/brain/clinical_copy_linter_test.dart`).
- [ ] **Banned Directive Phrasing Verification**: No copy contains mandatory medical directives (`stop taking`, `do not take`, `switch to`, `reduce your dose`, or `avoid` without `consult`).
- [ ] **Non-Diagnostic Shield Banner**: `MedicalDisclaimerBanner` is present and unmodified on all affected screens.
- [ ] **Local Data Isolation**: No raw medication schedules, lab PDFs, or CGM readings are routed off-device unless explicit user cloud backup consent is active.
- [ ] **Pre-Ship Legal Review Gate**: Sign-off recorded by the compliance reviewer for this release.

---

### Non-Directive Phrasing Reference Guide

| ❌ Banned Directive Copy | ✅ Compliant Informational Phrasing |
| :--- | :--- |
| *"Avoid combining ibuprofen with your blood thinner."* | *"Ibuprofen and blood thinners can interact. Consult your doctor before combining both."* |
| *"Stop your statin before this workout."* | *"Statins are sometimes associated with exercise-related muscle soreness. Consult your physician if you experience unusual fatigue."* |
| *"Do not take metformin with high carbs."* | *"Metformin combined with simple carbs may alter glucose response. Consult your dietitian regarding meal timing."* |
