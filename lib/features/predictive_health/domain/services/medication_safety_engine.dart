class MedicationSafetyEngine {
  const MedicationSafetyEngine();

  /// Detects food, nutrient, and timing interaction warnings for common Indian prescription medications
  String? getFoodInteractionWarning(String medicationName) {
    final lower = medicationName.toLowerCase();

    if (lower.contains('metformin')) {
      return 'Take with or immediately after meals to reduce stomach upset. Long-term use may deplete Vitamin B12; ensure B12-rich foods or regular testing.';
    } else if (lower.contains('thyronorm') || lower.contains('levothyroxine') || lower.contains('eltroxin')) {
      return 'Take on an empty stomach with plain water at least 30–60 minutes before morning tea/breakfast. Avoid milk, calcium, and iron supplements within 4 hours.';
    } else if (lower.contains('atorvastatin') || lower.contains('rosuvastatin')) {
      return 'Best taken at night when endogenous cholesterol synthesis peaks. Avoid grapefruit and excessive alcohol.';
    } else if (lower.contains('telmisartan') || lower.contains('amlodipine') || lower.contains('losartan')) {
      return 'Take consistently at the same time daily. Maintain low dietary sodium and avoid sudden potassium supplement spikes without medical advice.';
    } else if (lower.contains('iron') || lower.contains('ferrous') || lower.contains('autrin') || lower.contains('orofer')) {
      return 'Absorbs best on empty stomach with Vitamin C (e.g. lemon water/Amla). Strictly avoid tea, coffee, and dairy for 2 hours before and after.';
    }

    return null;
  }

  /// Bilingual Hindi interaction warning
  String? getFoodInteractionWarningHindi(String medicationName) {
    final lower = medicationName.toLowerCase();

    if (lower.contains('metformin')) {
      return 'पेट की खराबी से बचने के लिए भोजन के साथ लें। लंबे समय के उपयोग में विटामिन बी12 की जांच कराते रहें।';
    } else if (lower.contains('thyronorm') || lower.contains('levothyroxine') || lower.contains('eltroxin')) {
      return 'सुबह खाली पेट गुनगुने पानी के साथ लें। चाय/नाश्ते से ३०-६० मिनट पहले लें और दूध/कैल्शियम से ४ घंटे दूर रखें।';
    } else if (lower.contains('atorvastatin') || lower.contains('rosuvastatin')) {
      return 'रात के समय भोजन के बाद लेना सबसे प्रभावी है। शराब और चकोतरे के सेवन से बचें।';
    } else if (lower.contains('telmisartan') || lower.contains('amlodipine') || lower.contains('losartan')) {
      return 'प्रतिदिन एक ही निश्चित समय पर लें। भोजन में नमक की मात्रा नियंत्रित रखें।';
    } else if (lower.contains('iron') || lower.contains('ferrous') || lower.contains('autrin') || lower.contains('orofer')) {
      return 'नींबू पानी या आंवले के साथ लेना सबसे अच्छा है। दवा के २ घंटे पहले और बाद में चाय/कॉफी बिल्कुल न पिएं।';
    }

    return null;
  }
}
