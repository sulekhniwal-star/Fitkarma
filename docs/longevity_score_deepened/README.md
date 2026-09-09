# Deepened Longevity Score & 7 Hallmarks of Aging Engine

## 1. Overview
The **Deepened Longevity Score** system elevates FitKarma's predictive health intelligence to the molecular and geroscience domain. It evaluates **7 Fundamental Hallmarks of Aging**, calculates a **Composite Cellular Resilience Index (0–100)**, factors in the **South Asian Thin-Fat Phenotype** (visceral adiposity, TG:HDL ratio, Lipoprotein(a)), and generates an actionable **90-Day Cellular Longevity Roadmap** pairing modern geroprotective triggers with Ayurvedic Rasayana therapies.

---

## 2. The 7 Biological Hallmarks Evaluated

| Hallmark of Aging | Primary Biomarker | Weight | Cellular & Anti-Aging Pathway |
| :--- | :--- | :--- | :--- |
| **Mitochondrial Health** | Estimated $\text{VO}_2\text{ Max}$ | $18\%$ | Electron transport chain ATP synthesis & mitophagy clearance |
| **Telomere Integrity** | Resting Pulse (RHR) | $15\%$ | DNA repeat sequence preservation & sympathetic strain reduction |
| **Proteostasis & AGEs** | Fasting Blood Glucose | $15\%$ | Glycation end-product mitigation & arterial collagen elasticity |
| **Epigenetic Stability** | HRV RMSSD | $14\%$ | Parasympathetic vagal tone & Horvath methylation clock control |
| **Inflammaging** | High-Sensitivity CRP (hs-CRP) | $14\%$ | Cytokine cascade suppression & vascular endothelial nitric oxide |
| **Nutrient Sensing / mTOR** | Skeletal Muscle Mass (kg) | $12\%$ | AMPK metabolic switch balance & sarcopenic frailty prevention |
| **Stem Cell Regeneration** | Deep NREM Stage 3 Sleep | $12\%$ | Growth hormone pulses & neural glymphatic clearance |

---

## 3. South Asian Phenotype Calibration

South Asian populations experience unique cardiometabolic risks characterised by the **Thin-Fat Phenotype** (normal/low BMI with disproportionately high visceral adipose tissue and hepatic ectopic fat).

- **Visceral Adiposity Index**: Penalizes scores when visceral fat index exceeds $8.0$.
- **Atherogenic Ratio (TG:HDL)**: Flags high remnant cholesterol when ratio $> 2.5$.
- **Lipoprotein(a)**: Incorporates independent genetic cardiovascular risk deduction.
- **Sarcopenic Vulnerability**: Prioritizes progressive resistance training and Ayurvedic Rasayanas for muscle preservation.

---

## 4. 90-Day Cellular Longevity Roadmap

| Phase | Focus & Timeline | Key Action Protocols | Ayurvedic Rasayana |
| :--- | :--- | :--- | :--- |
| **Phase 1** | **Mitophagy & Autophagy Priming** (Weeks 1–4) | 14:10 Circadian fasting, Zone 2 cardio (3x/wk), Pomegranate polyphenols | Shilajit (Fulvic Acid Complex) & Triphala Churna |
| **Phase 2** | **Telomerase & Vascular Tone** (Weeks 5–8) | Compound strength training, Cold finish showers, Nitric oxide precursors | Ashwagandha KSM-66 & Arjuna Bark Kwath |
| **Phase 3** | **Epigenetic Consolidation** (Weeks 9–12) | Evening digital sunset, Thermal heat shock therapy (Sauna/steam), Methylation B-complex | Amalaki Rasayana (Chyawanprash) & Brahmi |

---

## 5. Architectural Components

### Domain Layer
- **`deepened_longevity_models.dart`**: Domain models for `HallmarkOfAging`, `HallmarkEvaluation`, `SouthAsianPhenotypeRisk`, `LongevityRoadmapPhase`, and `DeepenedLongevityReport`.
- **`deepened_longevity_engine.dart`**: Deterministic pure-Dart computation engine computing multi-hallmark weights, biological age deltas, and phenotypic risk profiling.

### Presentation Layer
- **`deepened_longevity_provider.dart`**: Riverpod `StateNotifierProvider` managing report state and real-time biometric adjustments.
- **`deepened_longevity_screen.dart`**: Premium dark-mode Bento UI displaying composite cellular resilience, 7 hallmarks progress gauges, South Asian phenotype tiles, and interactive biometrics tuner.

---

## 6. Verification & Security
- **100% Offline**: All calculations, biological age adjustments, and roadmap algorithms run entirely on-device without network dependency.
- **Security Rules**: No new unauthenticated data paths or external cloud sync requirements.
- **Unit Tests**: Full test suite in `test/features/predictive_health/deepened_longevity_test.dart` passing with 100% test coverage.
