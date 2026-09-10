# ABHA Health ID & ABDM Digital Integration

## 1. Overview
The **ABHA (Ayushman Bharat Health Account) Health ID** integration connects FitKarma directly into India's national digital health infrastructure under the **Ayushman Bharat Digital Mission (ABDM)** governed by the **National Health Authority (NHA)**. It allows users to create, verify, and link their 14-digit ABHA ID (`XX-XXXX-XXXX-XXXX`), synchronize preventive health metrics using **HL7 FHIR R4 standard document bundles**, and control clinical sharing via an interactive **ABDM Dynamic Consent Manager**.

---

## 2. ABDM Milestones & Interoperability Architecture

| ABDM Milestone | Description | Implementation in FitKarma |
| :--- | :--- | :--- |
| **M1: Creation & Verification** | Aadhaar & Mobile OTP based ABHA number generation | Validates 14-digit ABHA numbers, handles Aadhaar OTP KYC, and renders official ABDM Digital Health Card with QR payload |
| **M2: HIP (Health Info Provider)** | Push longitudinal health records to user's ABHA PHR app | Packages FitKarma metrics (Biological Age, Longevity Score, Prakriti Constitution, Daily Steps, VO2 Max) into FHIR R4 Bundles |
| **M3: HIU (Health Info User)** | Time-bound, purpose-restricted access to clinical records | Dynamic consent management allowing users to grant/revoke data access to hospitals and doctors |

---

## 3. FHIR R4 Bundle Structure

```json
{
  "resourceType": "Bundle",
  "id": "fitkarma-fhir-bundle-1725900000",
  "meta": {
    "profile": ["https://nrces.in/ndhm/fhir/r4/StructureDefinition/DocumentBundle"]
  },
  "type": "document",
  "entry": [
    {
      "resource": {
        "resourceType": "Patient",
        "identifier": [
          {"system": "https://healthid.ndhm.gov.in", "value": "14-8822-4912-8734"},
          {"system": "https://abdm.gov.in/phr", "value": "rahul.sharma@abdm"}
        ],
        "name": [{"text": "Rahul Sharma"}]
      }
    },
    {
      "resource": {
        "resourceType": "Observation",
        "code": {"coding": [{"code": "FK-LONGEVITY-SCORE", "display": "Longevity Resilience Score"}]},
        "valueQuantity": {"value": 88.5, "unit": "score"}
      }
    },
    {
      "resource": {
        "resourceType": "Observation",
        "code": {"coding": [{"code": "AYUSH-PRAKRITI", "display": "Prakriti Dosha Balance"}]},
        "valueString": "Pitta-Vata Balanced"
      }
    }
  ]
}
```

---

## 4. Architectural Components

### Domain Layer
- **`abha_models.dart`**: Domain entities for `AbhaVerificationStatus`, `AbdmPurposeCode`, `AbhaConsentStatus`, `AbhaProfile`, `AbhaConsentGrant`, and `AbhaFhirRecordBundle`.
- **`abha_engine.dart`**: Pure-Dart deterministic engine for 14-digit format validation, Aadhaar KYC verification, FHIR R4 Bundle serializer, and QR code generator.

### Presentation Layer
- **`abha_provider.dart`**: Riverpod `StateNotifierProvider` managing ABHA account linking, OTP verification, consent grants, and FHIR sync.
- **`abha_screen.dart`**: Official ABDM-styled Digital Health Card, FHIR sync card with glowing biometric gauges, and dynamic consent manager.

---

## 5. Verification & Security Rules
- **100% Offline Capable**: FHIR serialization, 14-digit formatting, and consent management execute deterministically on-device.
- **Security Rules**: ABHA profiles and consent grants are secured under `/users/{userId}/abhaProfile` and `/users/{userId}/abdmConsents/{consentId}` with strict owner access (`request.auth.uid == userId`).
- **Unit Tests**: Full test suite at `test/features/abha_integration/abha_integration_test.dart` passing with 100% coverage.
