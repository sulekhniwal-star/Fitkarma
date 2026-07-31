/// Indian Cultural Festival Model
class FestivalEvent {
  final String id;
  final String name;
  final DateTime startDate;
  final int durationDays;
  final String description;
  final bool isSurvivalModeActive;

  const FestivalEvent({
    required this.id,
    required this.name,
    required this.startDate,
    required this.durationDays,
    required this.description,
    this.isSurvivalModeActive = false,
  });
}

/// Fasting Mode Configuration
class FastingModeConfig {
  final bool isNavratriFastingActive;
  final bool isRamadanModeActive;
  final List<String> allowedFastingFoods;

  const FastingModeConfig({
    this.isNavratriFastingActive = false,
    this.isRamadanModeActive = false,
    this.allowedFastingFoods = const [
      'Sabudana Khichdi',
      'Kuttu Atta Dosa',
      'Samak Rice Khichdi',
      'Makhana Roasted',
      'Paneer Tikka',
    ],
  });
}

/// Seeded 10-Festival Indian Calendar Taxonomy
class SeededFestivalCalendar {
  static final List<FestivalEvent> festivals = [
    FestivalEvent(id: 'fest_1', name: 'Diwali', startDate: DateTime(2026, 11, 1), durationDays: 5, description: 'Pre-compensation caloric buffer & post-feast recovery'),
    FestivalEvent(id: 'fest_2', name: 'Navratri', startDate: DateTime(2026, 10, 10), durationDays: 9, description: 'Satvik fasting food filter & high-protein vegetarian options'),
    FestivalEvent(id: 'fest_3', name: 'Ramadan', startDate: DateTime(2026, 3, 1), durationDays: 30, description: 'Sehri pre-dawn hydration & Iftar post-sunset replenishment'),
    FestivalEvent(id: 'fest_4', name: 'Holi', startDate: DateTime(2026, 3, 25), durationDays: 2, description: 'Active hydration & festive sweet calorie balancing'),
    FestivalEvent(id: 'fest_5', name: 'Durga Puja', startDate: DateTime(2026, 10, 15), durationDays: 5, description: 'Pandal walking step booster & protein prioritization'),
    FestivalEvent(id: 'fest_6', name: 'Ganesh Chaturthi', startDate: DateTime(2026, 9, 14), durationDays: 10, description: 'Modak portions & balanced modak substitution'),
    FestivalEvent(id: 'fest_7', name: 'Karwa Chauth', startDate: DateTime(2026, 10, 28), durationDays: 1, description: 'Sargi pre-fast nutrition & hydration preservation'),
    FestivalEvent(id: 'fest_8', name: 'Pongal / Makar Sankranti', startDate: DateTime(2026, 1, 14), durationDays: 4, description: 'Jaggery & sesame seed macro accounting'),
    FestivalEvent(id: 'fest_9', name: 'Eid-ul-Fitr', startDate: DateTime(2026, 3, 31), durationDays: 2, description: 'Post-fast feast balance & protein allocation'),
    FestivalEvent(id: 'fest_10', name: 'Onam', startDate: DateTime(2026, 8, 25), durationDays: 4, description: 'Onam Sadya feast portion scaling'),
  ];
}
