# Deepened Environmental Health & Ritu-Charya Bioclimatic OS

## 1. Overview
The **Deepened Environmental Health Layer** expands FitKarma's atmospheric monitoring into a comprehensive bioclimatic intelligence system tailored for India. It models **Multi-Pollutant Particulate Speciation ($\text{PM}_{2.5}, \text{PM}_{10}, \text{NO}_2, \text{SO}_2, \text{CO}, \text{O}_3$)**, calculates **Cardiopulmonary Exercise Stress & Inhaled Particulate Deposition**, detects **Winter Morning Thermal Smog Inversion Traps**, evaluates **Wet-Bulb Globe Temperature (WBGT) & Electrolyte Deficits**, and incorporates classical **Ayurvedic Ritu-Charya (6-Season Bioclimatic Lifestyle & Nutrition Protocols)**.

---

## 2. Multi-Pollutant Speciation & Deposition Modeling

| Pollutant | Environmental Source | Clinical & Physiological Impact | WHO Threshold |
| :--- | :--- | :--- | :--- |
| **$\text{PM}_{2.5}$** | Vehicular, biomass, stubble burning | Deep alveolar penetration, endothelial inflammation, arterial plaque | $\le 15\ \mu\text{g/m}^3$ (24h) |
| **$\text{PM}_{10}$** | Road dust, construction debris | Tracheobronchial irritation, airway hyper-responsiveness | $\le 45\ \mu\text{g/m}^3$ (24h) |
| **$\text{NO}_2$** | High-temperature combustion, diesel exhaust | Nitrosative stress, exercise-induced bronchospasm | $\le 25\ \text{ppb}$ |
| **$\text{SO}_2$** | Industrial emissions, coal combustion | Acute bronchoconstriction in aerobic training | $\le 15\ \text{ppb}$ |
| **$\text{O}_3$** (Ground-Level) | Photochemical sunlight reaction | Post-noon oxidative alveolar epithelial cell injury | $\le 50\ \text{ppb}$ |
| **$\text{CO}$** | Incomplete fuel combustion | Carboxyhemoglobin elevation, reducing $\text{VO}_2\text{ Max}$ | $\le 4\ \text{ppm}$ |

### Inhaled Particulate Burden Formula:
$$\text{Inhaled PM}_{2.5}\ (\mu\text{g/hr}) = \dot{V}_E\ (2.7\ \text{m}^3\text{/hr}) \times \text{PM}_{2.5}\ (\mu\text{g/m}^3) \times \text{Alveolar Deposition Fraction}\ (0.75)$$

---

## 3. Cardiopulmonary Clearance & Training Modes

| Training Mode | AQI Range | $\text{PM}_{2.5}$ Range | Mask Tier | Training Guidance |
| :--- | :--- | :--- | :--- | :--- |
| **Unrestricted Outdoor** | $0 - 99$ | $< 45\ \mu\text{g/m}^3$ | None | Clean air for VO2 Max intervals, tempo runs, and cycling |
| **Outdoor Zone 1–2 Only** | $100 - 179$ | $45 - 89\ \mu\text{g/m}^3$ | Optional | Moderate air quality. Low-intensity walking & base cardio permitted |
| **Indoor Air-Purified Only** | $180 - 299$ | $90 - 179\ \mu\text{g/m}^3$ | N95 Recommended | Shift workouts indoors to HEPA-purified spaces; prevent deep lung deposition |
| **Hazardous Halt** | $\ge 300$ | $\ge 180\ \mu\text{g/m}^3$ | N99 Mandatory | Suspend strenuous exertion; light mobility, indoor pranayama & rest |

---

## 4. Ayurvedic Ritu-Charya Bioclimatic Adaptations

| Season (ऋतु) | Months | Dosha Dynamic | Herbal Respiratory Shield | Hydration & Electrolyte Formula |
| :--- | :--- | :--- | :--- | :--- |
| **Shishira** (Late Winter) | Jan – Feb | Vata accumulation, cold smog | Tulsi, Pippali, Sunthi (Ginger) kwath with raw honey | Warm water with Saunf, Ajwain & Himalayan pink salt |
| **Vasanta** (Spring) | Mar – Apr | Kapha liquefaction, pollen surge | Sitopaladi Churna with Vasa (*Adhatoda vasica*) | Warm water with Lemon, Honey & Turmeric |
| **Grishma** (Summer) | May – Jun | Pitta accumulation, intense heat | Yashtimadhu (Licorice) & Chandan infusion | Tender Coconut Water, Kokum Sharbat, Nimbu Pani with rock salt |
| **Varsha** (Monsoon) | Jul – Aug | Vata aggravation, damp agni | Trikatu Churna (Black Pepper, Long Pepper, Ginger) | Copper-vessel boiled Jira (Cumin) water |
| **Sharad** (Autumn) | Sep – Oct | Pitta flare (October heat) | Amalaki (Amla) juice & Shankhpushpi | Vetiver (Ushira) water & Mint lemonade |
| **Hemanta** (Early Winter) | Nov – Dec | Strong agni, winter inversion smog | Chyawanprash with warm milk & Pippali | Warm Ginger-Coriander infusion with Jaggery |

---

## 5. Architectural Components

### Domain Layer
- **`deepened_environmental_models.dart`**: Domain entities for `PollutantBreakdown`, `RituSeason`, `RituCharyaGuidance`, `TrainingEnvironmentMode`, `ProtectiveMaskTier`, `CardioPulmonaryStressIndex`, `ThermalStrainIndex`, and `DeepenedEnvironmentalReport`.
- **`deepened_environmental_engine.dart`**: Deterministic pure-Dart calculation engine computing multi-pollutant speciation, pulmonary particulate deposition, WBGT thermal strain, and Ritu-Charya seasonal mappings.

### Presentation Layer
- **`deepened_environmental_provider.dart`**: Riverpod `StateNotifierProvider` managing atmospheric state and live simulation parameters.
- **`deepened_environmental_screen.dart`**: Premium dark-mode Bento UI displaying the Atmospheric Safety Score, speciation tile grid, pulmonary clearance card, thermal strain gauges, and Ritu-Charya recommendations.

---

## 6. Verification & Security
- **100% Offline**: Pure Dart mathematical algorithms execute on-device with zero required external network calls.
- **Security Rules**: Inherits existing user-scoped security rules under `/users/{userId}/environmentalHealth/**`.
- **Unit Tests**: Full test suite in `test/features/environmental_health/deepened_environmental_test.dart` passing with 100% test coverage.
