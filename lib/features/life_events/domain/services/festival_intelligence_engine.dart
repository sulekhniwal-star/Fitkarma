import '../models/life_event_models.dart';

class FestivalIntelligenceEngine {
  const FestivalIntelligenceEngine();

  /// Returns full festival intelligence database for Indian cultural and religious events
  List<FestivalProtocol> getAllProtocols() {
    return [
      const FestivalProtocol(
        id: 'fest_navratri',
        name: 'Navratri Fasting & Shakti Protocol',
        nameHindi: 'नवरात्रि व्रत व शक्ति प्रोटोकॉल',
        seasonDescription: '9 days of sattvic fasting and Garba/Dandiya endurance.',
        nutritionGuidelines: [
          'Prioritize Kuttu (Buckwheat) and Singhara (Water Chestnut) over fried Sabudana vada.',
          'Incorporate Paneer, curd, roasted makhana, and pumpkin/lauki sabzi.',
          'Limit heavy ghee sweets; substitute with date-nut laddoos.',
        ],
        nutritionGuidelinesHindi: [
          'तले हुए साबूदाना वड़े के बजाय कुट्टू और सिंघाड़े के आटे की रोटी चुनें।',
          'पनीर, दही, भुना मखाना और लौकी की सब्जी से प्रोटीन बनाए रखें।',
          'अधिक घी वाली मिठाइयों के स्थान पर खजूर और मेवे का उपयोग करें।',
        ],
        fastingRules: [
          'Intermittent fasting window: 16:8 or fruit/sattvic meal once daily.',
          'Maintain electrolyte balance with coconut water and rock salt (Sendha Namak).',
        ],
        workoutAdaptations: [
          'Garba & Dandiya doubles as 600+ kcal aerobic cardio sessions!',
          'Perform moderate morning strength sessions with lighter weights.',
        ],
        feastBufferAdvice: 'Drink 500ml water and eat roasted makhana 30 mins before evening Garba celebrations.',
      ),
      const FestivalProtocol(
        id: 'fest_ramadan',
        name: 'Ramadan Circadian & Hydration Protocol',
        nameHindi: 'रमज़ान उपवास व हाइड्रेशन प्रोटोकॉल',
        seasonDescription: 'Dawn-to-dusk intermittent fasting optimization.',
        nutritionGuidelines: [
          'Suhoor: Slow-digesting complex carbs (Oats, Eggs, Chia seeds, Whole wheat roti).',
          'Iftar: Break fast with 2 dates, coconut water, followed by lean grilled meats and lentil soups.',
          'Avoid fried samosas and pakoras at Iftar to prevent severe blood sugar spikes.',
        ],
        nutritionGuidelinesHindi: [
          'सहरी: धीरे पचने वाले कार्ब्स और प्रोटीन (अंडे, ओट्स, चिया सीड्स, रोटी)।',
          'इफ्तार: खजूर और नारियल पानी से शुरुआत करें, तले हुए समोसे-पकौड़ों से बचें।',
        ],
        fastingRules: [
          'Drink 2.5L water systematically between Iftar and Suhoor.',
        ],
        workoutAdaptations: [
          'Schedule workouts 1 hour before Iftar (fasted) or 2 hours post-Iftar.',
          'Keep workouts strictly under 45 minutes to prevent dehydration.',
        ],
        feastBufferAdvice: 'Prioritize water and protein before diving into main Iftar banquet dishes.',
      ),
      const FestivalProtocol(
        id: 'fest_diwali',
        name: 'Diwali Feast & Mithai Damage Control',
        nameHindi: 'दीपावली दावत व मिठाई संतुलन',
        seasonDescription: 'Mitigate calorie surges and glycemic spikes during festive banquets.',
        nutritionGuidelines: [
          'Follow the "Protein & Fiber First" rule before eating sweets.',
          'Choose milk-based mithai (Rasgulla, Sandesh, Paneer Kheer) over deep-fried maida sweets (Jalebi, Gulab Jamun).',
          'Sip warm water with lemon and ginger post-feast to assist gastric motility.',
        ],
        nutritionGuidelinesHindi: [
          'मिठाई खाने से पहले प्रोटीन और सलाद का सेवन करें।',
          'तली हुई मैदे की मिठाई की जगह छेना और पनीर से बनी मिठाइयां चुनें।',
        ],
        fastingRules: [
          'Practice 16-hour digestive reset the morning after a heavy Diwali dinner.',
        ],
        workoutAdaptations: [
          'Complete a heavy full-body hypertrophy session on Diwali morning to prime muscle glycogen stores.',
        ],
        feastBufferAdvice: 'Pre-feast buffer: 30g whey protein or boiled eggs + 500ml water before visiting relatives.',
      ),
      const FestivalProtocol(
        id: 'fest_karwa_chauth',
        name: 'Karwa Chauth Nirjala Fasting Protocol',
        nameHindi: 'करवा चौथ निर्जला व्रत प्रोटोकॉल',
        seasonDescription: 'Complete waterless fasting management and post-fast recovery.',
        nutritionGuidelines: [
          'Sargi: High-fiber fruits (banana, pomegranate), soaked almonds, paneer stuffed roti, coconut water.',
          'Night Break: Warm lemon honey water, followed by light khichdi with ghee. Avoid heavy fried food.',
        ],
        nutritionGuidelinesHindi: [
          'सरगी: भीगे बादाम, अनार, पनीर पराठा और नारियल पानी से हाइड्रेशन बनाएं।',
          'व्रत खोलते समय हल्का सुपाच्य भोजन (खिचड़ी/सूप) लें।',
        ],
        fastingRules: [
          'Avoid direct sun exposure and strenuous physical activity during the day.',
        ],
        workoutAdaptations: [
          'Rest day or gentle evening restorative yoga/pranayama only.',
        ],
        feastBufferAdvice: 'Hydrate with room-temperature electrolyte water before heavy dinner.',
      ),
    ];
  }

  /// Get specific protocol by festival ID
  FestivalProtocol? getProtocol(String festivalId) {
    final list = getAllProtocols();
    return list.firstWhere((f) => f.id == festivalId, orElse: () => list.first);
  }
}
