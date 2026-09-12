enum FestivalType {
  navratri,
  ekadashi,
  ramadan,
  karwaChauth,
  diwaliFeast,
  generalFasting,
}

class FastingProtocol {
  final FestivalType type;
  final String title;
  final String titleHindi;
  final List<String> allowedFoods;
  final List<String> foodsToLimit;
  final List<String> macroStrategies;

  const FastingProtocol({
    required this.type,
    required this.title,
    required this.titleHindi,
    required this.allowedFoods,
    required this.foodsToLimit,
    required this.macroStrategies,
  });
}

class FestivalNutritionEngine {
  const FestivalNutritionEngine();

  FastingProtocol getProtocol(FestivalType type) {
    switch (type) {
      case FestivalType.navratri:
        return const FastingProtocol(
          type: FestivalType.navratri,
          title: 'Navratri Vrat Protocol',
          titleHindi: 'नवरात्रि व्रत पोषण निर्देशिका',
          allowedFoods: [
            'Kuttu (Buckwheat) Roti',
            'Singhara (Water Chestnut) Cheela',
            'Samak Rice (Barnyard Millet) Khichdi',
            'Roasted Makhana & Walnuts',
            'Fresh Paneer & Curd',
            'Sendha Namak (Rock Salt)',
          ],
          foodsToLimit: [
            'Deep-fried Sabudana Vada',
            'Excess Potato/Aloo Pakodas in Peanut Oil',
            'Refined Sugar Sabudana Kheer',
          ],
          macroStrategies: [
            'Use Kuttu or Singhara flour over pure Sabudana for 3x higher protein and lower glycemic surge.',
            'Keep Sendha Namak hydration consistent with tender coconut water and mint chaas.',
            'Air-fry or roast sweet potatoes and paneer rather than deep frying.',
          ],
        );

      case FestivalType.ekadashi:
        return const FastingProtocol(
          type: FestivalType.ekadashi,
          title: 'Ekadashi Grain-Free Fast',
          titleHindi: 'एकादशी व्रत नियम',
          allowedFoods: [
            'Fresh Seasonal Fruits (Papaya, Apple, Pomegranate)',
            'Chilled Buttermilk (Chaas) with Jeera',
            'Soaked Almonds & Raisins',
            'Roasted Foxnuts (Makhana)',
          ],
          foodsToLimit: [
            'All Grains, Dals, and Pulses',
            'Processed Snacks and Common Table Salt',
          ],
          macroStrategies: [
            'Rely on dairy (Paneer/Curd) and nuts for sustained amino acid balance throughout the day.',
            'Maintain minimum 3 liters fluid intake with electrolyte-rich lemon water.',
          ],
        );

      case FestivalType.ramadan:
        return const FastingProtocol(
          type: FestivalType.ramadan,
          title: 'Ramadan Suhoor & Iftar Protocol',
          titleHindi: 'रमज़ान सेहरी व इफ्तार गाइड',
          allowedFoods: [
            'Suhoor: Rolled Oats / Jowar Porridge with Eggs & Chia Seeds',
            'Iftar: 2 Medjool Dates + 500ml Water + Spiced Fruit Chaat',
            'Grilled Tandoori Chicken / Paneer Tikka with Green Chutney',
          ],
          foodsToLimit: [
            'Oily Rooh Afza / Rose Syrups with High Added Sugar',
            'Deep Fried Mutton / Chicken Samosas at Iftar Onset',
          ],
          macroStrategies: [
            'Suhoor: Focus on slow-burning complex fiber and protein to delay hunger for 12+ hours.',
            'Iftar: Break fast with 1-2 dates, hydrate with water, and wait 15 mins before having solid meals to prevent insulin spike.',
          ],
        );

      case FestivalType.karwaChauth:
        return const FastingProtocol(
          type: FestivalType.karwaChauth,
          title: 'Karwa Chauth Sargi & Parana',
          titleHindi: 'करवा चौथ सरगी व पारण',
          allowedFoods: [
            'Sargi: Soaked Almonds, Walnuts, Paneer Stuffed Roti, Banana & Milk',
            'Parana: Warm Moong Dal Khichdi with Ghee & Curd',
          ],
          foodsToLimit: [
            'High-Sodium Mathri & Heavily Sugared Feni at Pre-Dawn',
            'Heavy Spicy Oily Dinner right after breaking fast',
          ],
          macroStrategies: [
            'Ensure pre-dawn Sargi has complex fats (nuts + ghee) to sustain blood glucose.',
            'Break the water fast gently with lukewarm water and a light digestive khichdi.',
          ],
        );

      case FestivalType.diwaliFeast:
      case FestivalType.generalFasting:
        return const FastingProtocol(
          type: FestivalType.diwaliFeast,
          title: 'Diwali & Feast Celebration Shield',
          titleHindi: 'त्योहार व दावत संतुलन नियम',
          allowedFoods: [
            'Pre-party Protein Shake or Greek Yogurt with Berries',
            'Dry Fruit Laddoos with Dates (No Refined Sugar)',
            'Tandoori / Grilled Kebabs with Salad First',
          ],
          foodsToLimit: [
            'Back-to-back Fried Mawa Sweets (Gulab Jamun, Jalebi)',
            'Sugary Sodas and Cocktails',
          ],
          macroStrategies: [
            'Follow the "Protein & Fiber First" rule: eat salad and protein before touching sweets.',
            'Practice the 1-Sweet Rule per social gathering to enjoy festivities guilt-free.',
          ],
        );
    }
  }
}
