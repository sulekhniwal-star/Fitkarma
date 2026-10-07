/// FitKarma — Indian Thali Combo Presets
/// Enables 1-tap logging of authentic regional Indian multi-item meals.
library;

class ThaliItem {
  final String name;
  final String hindiName;
  final String portion;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const ThaliItem({
    required this.name,
    required this.hindiName,
    required this.portion,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}

class ThaliPreset {
  final String id;
  final String title;
  final String hindiTitle;
  final String region;
  final String description;
  final List<ThaliItem> items;
  final String dietaryBadge; // Veg, Egg, Non-Veg, High-Protein

  const ThaliPreset({
    required this.id,
    required this.title,
    required this.hindiTitle,
    required this.region,
    required this.description,
    required this.items,
    required this.dietaryBadge,
  });

  double get totalCalories => items.fold(0, (sum, item) => sum + item.calories);
  double get totalProtein => items.fold(0, (sum, item) => sum + item.protein);
  double get totalCarbs => items.fold(0, (sum, item) => sum + item.carbs);
  double get totalFat => items.fold(0, (sum, item) => sum + item.fat);
}

class IndianThaliRepository {
  static const List<ThaliPreset> presets = [
    ThaliPreset(
      id: 'north_standard',
      title: 'North Indian Ghar Ki Thali',
      hindiTitle: 'उत्तर भारतीय संपूर्ण थाली',
      region: 'North India',
      description: 'Classic everyday balanced home thali with whole wheat roti, arhar dal, and seasonal sabzi.',
      dietaryBadge: 'Vegetarian 🌿',
      items: [
        ThaliItem(name: 'Phulka (Whole Wheat)', hindiName: 'फुल्का / रोटी', portion: '2 pcs', calories: 140, protein: 4.8, carbs: 28, fat: 1.0),
        ThaliItem(name: 'Dal Tadka (Toor/Arhar)', hindiName: 'दाल तड़का', portion: '1 bowl (150ml)', calories: 145, protein: 7.2, carbs: 20, fat: 4.0),
        ThaliItem(name: 'Paneer Bhurji / Matar Paneer', hindiName: 'पनीर भुर्जी', portion: '1 bowl (120g)', calories: 190, protein: 12.0, carbs: 6, fat: 13.0),
        ThaliItem(name: 'Steamed Rice', hindiName: 'चावल', portion: '1 small katori (100g)', calories: 130, protein: 2.7, carbs: 28, fat: 0.3),
        ThaliItem(name: 'Fresh Curd / Dahi', hindiName: 'ताज़ा दही', portion: '1 katori (100g)', calories: 60, protein: 3.5, carbs: 4.5, fat: 3.0),
        ThaliItem(name: 'Green Salad (Cucumber & Tomato)', hindiName: 'ककड़ी-टमाटर सलाद', portion: '1 plate', calories: 25, protein: 1.0, carbs: 5, fat: 0.2),
      ],
    ),
    ThaliPreset(
      id: 'desi_gym_protein',
      title: 'High-Protein Desi Muscle Thali',
      hindiTitle: 'हाई-प्रोटीन देसी जिम थाली',
      region: 'Pan-India',
      description: 'Power-packed 40g+ protein desi meal for active lifters and gym-goers.',
      dietaryBadge: 'High Protein 💪',
      items: [
        ThaliItem(name: 'Multigrain Roti (Wheat + Oats + Sattu)', hindiName: 'मल्टीग्रेन सत्तू रोटी', portion: '2 pcs', calories: 160, protein: 7.0, carbs: 26, fat: 2.0),
        ThaliItem(name: 'Egg Bhurji (3 eggs: 2 whites, 1 whole)', hindiName: 'अंडा भुर्जी', portion: '1 bowl', calories: 175, protein: 16.5, carbs: 3, fat: 11.0),
        ThaliItem(name: 'Sprouted Moong & Kala Chana Chaat', hindiName: 'अंकुरित मूंग चाट', portion: '1 bowl (120g)', calories: 130, protein: 9.0, carbs: 20, fat: 1.5),
        ThaliItem(name: 'Jeera Spiced Buttermilk / Chhaas', hindiName: 'जीरा छाछ', portion: '1 big glass (250ml)', calories: 45, protein: 3.2, carbs: 4, fat: 1.5),
        ThaliItem(name: 'Soya Chunks Masala Curry', hindiName: 'सोया चंक्स करी', portion: '1 bowl (100g)', calories: 160, protein: 18.0, carbs: 12, fat: 3.5),
      ],
    ),
    ThaliPreset(
      id: 'south_indian_meals',
      title: 'Traditional South Indian Meals',
      hindiTitle: 'दक्षिण भारतीय भोजन',
      region: 'South India',
      description: 'Wholesome southern feast with drumstick sambar, pepper rasam, and fresh vegetable poriyal.',
      dietaryBadge: 'Vegetarian 🌿',
      items: [
        ThaliItem(name: 'Steamed Sona Masoori Rice', hindiName: 'साधम / चावल', portion: '1 plate (150g)', calories: 195, protein: 4.0, carbs: 42, fat: 0.5),
        ThaliItem(name: 'Drumstick & Vegetable Sambar', hindiName: 'सांभर', portion: '1 large bowl (180ml)', calories: 135, protein: 5.5, carbs: 22, fat: 3.0),
        ThaliItem(name: 'Pepper Garlic Rasam', hindiName: 'रसम', portion: '1 katori (120ml)', calories: 40, protein: 1.2, carbs: 7, fat: 1.0),
        ThaliItem(name: 'Beans & Carrot Poriyal (with coconut)', hindiName: 'पोरियाल', portion: '1 cup (100g)', calories: 95, protein: 2.5, carbs: 11, fat: 4.5),
        ThaliItem(name: 'South Indian Set Curd', hindiName: 'थयिर / दही', portion: '1 cup (100g)', calories: 65, protein: 3.5, carbs: 4.5, fat: 3.2),
        ThaliItem(name: 'Roasted Appalam / Papad', hindiName: 'अप्पलम', portion: '1 pc (roasted)', calories: 35, protein: 1.5, carbs: 5, fat: 0.5),
      ],
    ),
    ThaliPreset(
      id: 'gujarati_thali',
      title: 'Kathiyawadi / Gujarati Thali',
      hindiTitle: 'काठियावाड़ी गुजराती थाली',
      region: 'Gujarat',
      description: 'Light, digestive Gujarati meal with sweet-tangy dal, khichdi, kadhi, and roasted rotli.',
      dietaryBadge: 'Vegetarian 🌿',
      items: [
        ThaliItem(name: 'Thin Phulka / Rotli', hindiName: 'रोटली', portion: '3 thin pcs', calories: 150, protein: 4.2, carbs: 30, fat: 1.0),
        ThaliItem(name: 'Gujarati Khatti-Meethi Dal', hindiName: 'गुजराती दाल', portion: '1 bowl (150ml)', calories: 125, protein: 5.0, carbs: 21, fat: 2.5),
        ThaliItem(name: 'Moong Dal Khichdi', hindiName: 'मूंग दाल खिचड़ी', portion: '1 small katori (120g)', calories: 160, protein: 5.8, carbs: 28, fat: 2.5),
        ThaliItem(name: 'Gujarati Besan Kadhi', hindiName: 'कढ़ी', portion: '1 bowl (120ml)', calories: 85, protein: 3.0, carbs: 9, fat: 3.5),
        ThaliItem(name: 'Ringan Olo / Baingan Bhartha', hindiName: 'रींगण ओलो', portion: '1 bowl (100g)', calories: 90, protein: 2.0, carbs: 11, fat: 4.0),
        ThaliItem(name: 'Masala Chaas', hindiName: 'छाश', portion: '1 glass (200ml)', calories: 35, protein: 2.5, carbs: 3, fat: 1.0),
      ],
    ),
    ThaliPreset(
      id: 'bengali_thali',
      title: 'Bengali Macher Jhol Thali',
      hindiTitle: 'বাঙালি মাছের থালি / बंगाली थाली',
      region: 'East India',
      description: 'Traditional Bengali feast with light mustard cumin fish curry and bhaja.',
      dietaryBadge: 'Non-Vegetarian 🐟',
      items: [
        ThaliItem(name: 'Govindobhog / Steamed Rice', hindiName: 'भात / चावल', portion: '1 plate (150g)', calories: 195, protein: 4.0, carbs: 42, fat: 0.5),
        ThaliItem(name: 'Rui Macher Patla Jhol', hindiName: 'रोहू मछली झोल', portion: '1 piece fish + curry', calories: 210, protein: 21.0, carbs: 6, fat: 11.0),
        ThaliItem(name: 'Bhaja Moong Dal', hindiName: 'मूंग दाल', portion: '1 bowl (140ml)', calories: 135, protein: 6.8, carbs: 21, fat: 2.8),
        ThaliItem(name: 'Begun Bhaja (Eggplant round)', hindiName: 'बेगुन भाजा', portion: '2 slices', calories: 85, protein: 1.5, carbs: 8, fat: 5.0),
        ThaliItem(name: 'Tomato Khejur Chutney', hindiName: 'टमाटर चटनी', portion: '2 tbsp', calories: 45, protein: 0.5, carbs: 10, fat: 0.2),
      ],
    ),
  ];
}
