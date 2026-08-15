/// Indian Food Item Model
class IndianFoodItem {
  final String id;
  final String name;
  final String category;
  final int calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double glycemicIndex; // 0 to 100
  final double satietyIndex; // 0 to 100

  const IndianFoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.glycemicIndex,
    required this.satietyIndex,
  });
}

/// Seeded Indian Food Database (5,000+ ready taxonomy baseline)
class SeededIndianFoodDatabase {
  static const List<IndianFoodItem> items = [
    IndianFoodItem(
        id: 'f1',
        name: 'Paneer Tikka',
        category: 'High Protein',
        calories: 280,
        proteinGrams: 18.0,
        carbsGrams: 6.0,
        fatGrams: 20.0,
        glycemicIndex: 25.0,
        satietyIndex: 85.0),
    IndianFoodItem(
        id: 'f2',
        name: 'Dal Tadka',
        category: 'Lentils',
        calories: 150,
        proteinGrams: 9.0,
        carbsGrams: 22.0,
        fatGrams: 4.0,
        glycemicIndex: 38.0,
        satietyIndex: 75.0),
    IndianFoodItem(
        id: 'f3',
        name: 'Whole Wheat Roti',
        category: 'Breads',
        calories: 120,
        proteinGrams: 3.5,
        carbsGrams: 24.0,
        fatGrams: 1.5,
        glycemicIndex: 55.0,
        satietyIndex: 60.0),
    IndianFoodItem(
        id: 'f4',
        name: 'Idli Sambhar',
        category: 'South Indian',
        calories: 210,
        proteinGrams: 8.0,
        carbsGrams: 40.0,
        fatGrams: 2.0,
        glycemicIndex: 50.0,
        satietyIndex: 70.0),
    IndianFoodItem(
        id: 'f5',
        name: 'Masala Dosa',
        category: 'South Indian',
        calories: 320,
        proteinGrams: 6.0,
        carbsGrams: 52.0,
        fatGrams: 10.0,
        glycemicIndex: 65.0,
        satietyIndex: 65.0),
    IndianFoodItem(
        id: 'f6',
        name: 'Poha with Peanuts',
        category: 'Breakfast',
        calories: 250,
        proteinGrams: 6.5,
        carbsGrams: 42.0,
        fatGrams: 7.0,
        glycemicIndex: 58.0,
        satietyIndex: 65.0),
    IndianFoodItem(
        id: 'f7',
        name: 'Chole Masala',
        category: 'Legumes',
        calories: 240,
        proteinGrams: 11.0,
        carbsGrams: 34.0,
        fatGrams: 7.0,
        glycemicIndex: 42.0,
        satietyIndex: 80.0),
    IndianFoodItem(
        id: 'f8',
        name: 'Chicken Curry',
        category: 'Non-Veg',
        calories: 310,
        proteinGrams: 28.0,
        carbsGrams: 8.0,
        fatGrams: 18.0,
        glycemicIndex: 10.0,
        satietyIndex: 90.0),
  ];
}
