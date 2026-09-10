# Corporate Wellness & Insurer Tier Architecture

## 1. Overview
The **Corporate Wellness & Insurer Tier** aligns enterprise employee vitality with health insurance economics in India. Compliant with **IRDAI (Insurance Regulatory and Development Authority of India) Wellness Guidelines**, it enables users to earn **dynamic annual health insurance premium rebates (up to 30% / ₹5,000–₹8,000+ per year)** from major Indian insurers (HDFC ERGO, Star Health, ICICI Lombard, Aditya Birla Activ Health) through validated daily physical movement, Shatapadi adherence, and circadian longevity tracking.

---

## 2. IRDAI Dynamic Premium Rebate Calculation

$$\text{Discount \%} = \min\left(\text{Max Insurer Cap},\ \Delta\text{Steps} + \Delta\text{Longevity} + \Delta\text{Shatapadi} + \Delta\text{Consistency}\right)$$

| Performance Factor | Metric Requirement | Maximum Rebate Contribution |
| :--- | :--- | :--- |
| **Physical Step Cadence** | $\ge 10,000\ \text{steps/day}$ ($7.5\%\text{ for } 8\text{K}$) | **$+10.0\%$** |
| **Longevity Resilience Score** | Composite Score $\ge 85.0\ (/100)$ | **$+8.0\%$** |
| **Post-Meal Shatapadi Adherence** | $\ge 80\%\text{ dinner walk consistency}$ | **$+5.0\%$** |
| **Monthly Workout Consistency** | $\ge 20\ \text{active logging days/month}$ | **$+7.0\%$** |

### Annual Rupee Savings:
$$\text{Annual Savings (₹)} = \text{Base Policy Premium (₹)} \times \text{Calculated Discount Percentage}$$

---

## 3. Integrated Insurer Partners

| Insurer Partner | Policy ID Prefix | Maximum Allowable Discount | Risk Stratification |
| :--- | :--- | :--- | :--- |
| **HDFC ERGO Health** | `HE-FIT` | **$25.0\%$** | Preferred Elite / Standard / Elevated |
| **Star Health & Allied** | `STAR-FIT` | **$30.0\%$** | Preferred Elite / Standard / Elevated |
| **ICICI Lombard** | `ICICI-FIT` | **$20.0\%$** | Preferred Elite / Standard / Elevated |
| **Aditya Birla Activ Health** | `AB-ACTIV` | **$30.0\%$** | Preferred Elite / Standard / Elevated |

---

## 4. Corporate Team Challenges & Workplace Ergonomics

- **Inter-Department Step Sprints**: Enterprise-wide team leaderboards (e.g., Engineering vs Product 100K Steps).
- **50-Minute Desk Sedentary Alerts**: Cervical spine rotations and posture resets.
- **20-20-20 Eye Strain Protocol**: Preventing digital eye strain and ciliary muscle fatigue.
- **Office Corridor Shatapadi**: Post-lunch 5-minute campus walk prompts.

---

## 5. Architectural Components

### Domain Layer
- **`corporate_models.dart`**: Domain entities for `CorporateOrganization`, `CorporateEmployeeProfile`, `InsurerPartner`, `InsurerRiskTier`, `InsurerPremiumRebate`, `CorporateTeamChallenge`, and `ErgonomicAlert`.
- **`corporate_engine.dart`**: Pure-Dart deterministic engine for IRDAI rebate percentages, annual rupee savings, work email OTP validation, and workplace ergonomic alerts.

### Presentation Layer
- **`corporate_provider.dart`**: Riverpod `StateNotifierProvider` managing corporate enrollment, work email OTP verification, insurer policy linkage, and dynamic rebate calculation.
- **`corporate_wellness_screen.dart`**: Bento UI featuring Corporate Employee ID badge, Insurer Premium Rebate Calculator with glowing rupee savings, Team Challenges progress bar, and Ergonomic alerts.

---

## 6. Verification & Security Rules
- **100% Offline Capable**: Pure-Dart math calculations execute on-device without cloud dependencies.
- **Security Rules**: Corporate profiles and policy numbers are secured under `/users/{userId}/corporateProfile` and `/users/{userId}/insurerRebates/{policyId}` with strict `request.auth.uid == userId` authorization.
- **Unit Tests**: Full test suite at `test/features/corporate_wellness/corporate_wellness_test.dart` passing with 100% test coverage.
