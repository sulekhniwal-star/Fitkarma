# Deepened Adaptive Metabolism Engine & Leptin Refeed Cycling

## 1. Overview
The **Deepened Adaptive Metabolism Engine** expands FitKarma's metabolic intelligence from single-number TDEE estimation into a multi-vector physiological system. It quantifies **Adaptive Thermogenesis ($\Delta AT$)**, decomposes energy expenditure ($BMR + TEF + EAT + NEAT$), calculates **Metabolic Resistance Scores (0–100)**, triggers structured **Leptin Refeeds / Diet Breaks**, and incorporates **Ayurvedic Jatharagni Chrono-Nutrition**.

---

## 2. Energy Expenditure Decomposition

$$\text{TDEE} = \text{BMR} + \text{TEF} + \text{EAT} + \text{NEAT}$$

| Component | Physiological Basis | Contribution |
| :--- | :--- | :--- |
| **BMR** (Basal Metabolic Rate) | Katch-McArdle / Mifflin-St Jeor | ~60 – 70% |
| **TEF** (Thermic Effect of Food) | Protein-weighted digestive expenditure ($12\%$) | ~10 – 15% |
| **EAT** (Exercise Thermogenesis) | MET $\times$ workout minutes | ~5 – 15% |
| **NEAT** (Non-Exercise Activity) | Step cadence & daily postural movements | ~15 – 20% |

---

## 3. Adaptive Thermogenesis & Refeed Protocols

| Metabolic State | Adaptation Factor | Jatharagni State | Refeed Protocol |
| :--- | :--- | :--- | :--- |
| **Normal / Primed** | $0.93 - 1.07$ | Samagni (समाग्नि) | Standard Deficit |
| **Mild Suppression** | $0.88 - 0.92$ | Vishamagni (विषमाग्नि) | 48-Hour Leptin Refeed (+350 kcal, +75g carbs) |
| **Severe Down-Regulation** | $< 0.88$ ($6+$ weeks) | Mandagni (मंदाग्नि) | 7-Day Maintenance Diet Break (+450 kcal) |

---

## 4. Architectural Components

### Domain Layer
- **`deepened_metabolism_models.dart`**: `JatharagniState`, `RefeedProtocol`, `EnergyExpenditureDecomposition`, `MacroCyclingPlan`, and `DeepenedMetabolismReport`.
- **`deepened_metabolism_engine.dart`**: Pure Dart deterministic engine decomposing TDEE, evaluating adaptive thermogenesis, computing resistance scores, and generating training/rest macro cycles.

### Presentation Layer
- **`deepened_metabolism_provider.dart`**: Riverpod `StateNotifierProvider` managing live day-type macro cycling and refeed window activation.
- **`deepened_metabolism_screen.dart`**: Premium dark-mode Bento UI displaying true dynamic TDEE, expenditure decomposition progress bars, macro-cycling pills, and refeed manager.

---

## 5. Offline Verification & Testing
- **100% Offline Capable**: All mathematical decompositions, Katch-McArdle calculations, and chrono-nutrition tips execute on-device without cloud dependency.
- **Unit Tests**: Full test suite in `test/features/metabolism/deepened_metabolism_test.dart` passing with 100% coverage.
