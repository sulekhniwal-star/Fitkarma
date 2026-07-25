/// §P12-A Indian Festival Calendar Dataset (2026–2027)
///
/// Comprehensive pan-Indian festival dates with cultural, dietary, and physical activity traits matching §P12-A spec.
library;

enum FestivalCategory {
  feasting, // Sweets, heavy meals (Diwali, Eid, Holi)
  fasting, // Grains prohibited, dry/water fasts (Karwa Chauth, Navratri, Janmashtami)
  harvest, // Traditional grains, feasts (Pongal, Onam, Baisakhi, Sankranti)
  community, // High physical movement, dance (Ganesh Chaturthi, Durga Puja, Garba)
}

class IndianFestival {
  const IndianFestival({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.dietaryGuidance,
    required this.recommendedActivity,
    this.isFastingRequired = false,
    this.isHighCarbFeast = false,
  });

  final String id;
  final String name;
  final String hindiName;
  final FestivalCategory category;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String dietaryGuidance;
  final String recommendedActivity;
  final bool isFastingRequired;
  final bool isHighCarbFeast;
}

class IndianFestivalCalendarDataset {
  const IndianFestivalCalendarDataset();

  /// Pan-Indian Festival Dataset (2026–2027)
  static final List<IndianFestival> festivals = [
    // 1. Makar Sankranti / Pongal
    IndianFestival(
      id: 'sankranti_2026',
      name: 'Makar Sankranti & Pongal 🌾',
      hindiName: 'मकर संक्रांति',
      category: FestivalCategory.harvest,
      startDate: DateTime(2026, 1, 14),
      endDate: DateTime(2026, 1, 15),
      description: 'Harvest festival celebrated across India with sesame, jaggery & sweet pongal.',
      dietaryGuidance: 'Enjoy sesame (til) & jaggery snacks for healthy fats & iron.',
      recommendedActivity: '30-min morning kite-flying or brisk sunshine walk.',
      isHighCarbFeast: true,
    ),

    // 2. Holi
    IndianFestival(
      id: 'holi_2026',
      name: 'Holi 🎨',
      hindiName: 'होली',
      category: FestivalCategory.feasting,
      startDate: DateTime(2026, 3, 4),
      endDate: DateTime(2026, 3, 4),
      description: 'Festival of colors, Gujiya, Thandai, and outdoor celebrations.',
      dietaryGuidance: 'Hydrate with +1.0L extra water; enjoy 1-2 Gujiyas guilt-free with high-protein lunch.',
      recommendedActivity: 'Active outdoor movement & post-lunch 20-min walking burn.',
      isHighCarbFeast: true,
    ),

    // 3. Chaitra Navratri
    IndianFestival(
      id: 'chaitra_navratri_2026',
      name: 'Chaitra Navratri 🕉️',
      hindiName: 'चैत्र नवरात्रि',
      category: FestivalCategory.fasting,
      startDate: DateTime(2026, 3, 19),
      endDate: DateTime(2026, 3, 27),
      description: '9 Days Sattvic fasting with Kuttu, Singhara, Makhana & Sabudana.',
      dietaryGuidance: 'Focus on protein via roasted Makhana, Paneer, Curd, & Peanuts.',
      recommendedActivity: 'Low-RPE gentle yoga, bodyweight squats, and mobility stretching.',
      isFastingRequired: true,
    ),

    // 4. Eid ul-Fitr
    IndianFestival(
      id: 'eid_2026',
      name: 'Eid ul-Fitr 🌙',
      hindiName: 'ईद उल-फ़ित्र',
      category: FestivalCategory.feasting,
      startDate: DateTime(2026, 3, 20),
      endDate: DateTime(2026, 3, 21),
      description: 'Festive feast with Sheer Khurma, Biryani & family gatherings.',
      dietaryGuidance: 'Prioritize lean meat/paneer protein before sweet Sheer Khurma.',
      recommendedActivity: 'Post-feast 25-min evening stroll with family.',
      isHighCarbFeast: true,
    ),

    // 5. Raksha Bandhan
    IndianFestival(
      id: 'rakhi_2026',
      name: 'Raksha Bandhan 🧵',
      hindiName: 'रक्षाबंधन',
      category: FestivalCategory.community,
      startDate: DateTime(2026, 8, 28),
      endDate: DateTime(2026, 8, 28),
      description: 'Celebration of sibling bonds with home-made Indian Mithai.',
      dietaryGuidance: 'Share sweets mindfully & balance with a fiber-rich salad.',
      recommendedActivity: 'Morning 30-min upper body strength session.',
      isHighCarbFeast: true,
    ),

    // 6. Janmashtami
    IndianFestival(
      id: 'janmashtami_2026',
      name: 'Janmashtami 🪈',
      hindiName: 'जन्माष्टमी',
      category: FestivalCategory.fasting,
      startDate: DateTime(2026, 9, 3),
      endDate: DateTime(2026, 9, 3),
      description: 'Fasting until midnight; panjiri & makhan offerings.',
      dietaryGuidance: 'Hydrate well with buttermilk/coconut water; break fast with light fruits.',
      recommendedActivity: 'Light stretching and mobility work.',
      isFastingRequired: true,
    ),

    // 7. Ganesh Chaturthi
    IndianFestival(
      id: 'ganesh_chaturthi_2026',
      name: 'Ganesh Chaturthi 🐘',
      hindiName: 'गणेश चतुर्थी',
      category: FestivalCategory.community,
      startDate: DateTime(2026, 9, 14),
      endDate: DateTime(2026, 9, 24),
      description: '10 Days of Modak delicacies, Aarti gatherings & community processions.',
      dietaryGuidance: 'Opt for steamed Ukadiche Modak over fried versions when possible.',
      recommendedActivity: 'Active walking steps during Visarjan & pandal visits.',
      isHighCarbFeast: true,
    ),

    // 8. Sharad Navratri & Garba
    IndianFestival(
      id: 'sharad_navratri_2026',
      name: 'Sharad Navratri & Garba 💃',
      hindiName: 'शरद नवरात्रि',
      category: FestivalCategory.fasting,
      startDate: DateTime(2026, 10, 11),
      endDate: DateTime(2026, 10, 19),
      description: '9 Nights of Garba/Dandiya dance & Sattvic fasting.',
      dietaryGuidance: 'Replenish electrolytes with coconut water & curd during nightly Garba.',
      recommendedActivity: 'Garba dance doubles as high-calorie cardio workout (400+ kcal burn)!',
      isFastingRequired: true,
    ),

    // 9. Durga Puja / Dussehra
    IndianFestival(
      id: 'dussehra_2026',
      name: 'Dussehra & Durga Puja 🏹',
      hindiName: 'दशहरा / दुर्गा पूजा',
      category: FestivalCategory.community,
      startDate: DateTime(2026, 10, 20),
      endDate: DateTime(2026, 10, 20),
      description: 'Victory of Good over Evil! Bhog, pandal hopping & festive meals.',
      dietaryGuidance: 'Balance Khichuri Bhog with cucumber/tomato salad.',
      recommendedActivity: 'Pandal hopping walking goal: 10,000 steps.',
      isHighCarbFeast: true,
    ),

    // 10. Karwa Chauth
    IndianFestival(
      id: 'karwa_chauth_2026',
      name: 'Karwa Chauth 🌕',
      hindiName: 'करवाचौथ',
      category: FestivalCategory.fasting,
      startDate: DateTime(2026, 10, 28),
      endDate: DateTime(2026, 10, 28),
      description: 'Sunrise to moonrise dry fast.',
      dietaryGuidance: 'Pre-sunrise Sargi: Complex carbs (oats/paratha) + nuts. Post-moonrise: Slow hydration.',
      recommendedActivity: 'Rest day! Gentle restorative yoga & light breathing exercises.',
      isFastingRequired: true,
    ),

    // 11. Diwali
    IndianFestival(
      id: 'diwali_2026',
      name: 'Diwali 🪔',
      hindiName: 'दीपावली',
      category: FestivalCategory.feasting,
      startDate: DateTime(2026, 11, 8),
      endDate: DateTime(2026, 11, 10),
      description: 'Grand Festival of Lights! Sweets, dry fruits & festive dining.',
      dietaryGuidance: 'Pre-compensation buffer active: Enjoy Mithai guilt-free on main day.',
      recommendedActivity: 'Post-dinner 20-min metabolic walk & light morning workout.',
      isHighCarbFeast: true,
    ),
  ];
}
