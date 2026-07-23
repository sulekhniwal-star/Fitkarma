/// §P5-K Smart Festival Nutrition Adaptation & §P12-A Festival Intelligence
///
/// Pure-Dart festival calendar detection (Diwali, Holi, Navratri, Eid, Karwa Chauth),
/// 3-phase pre-compensation protocol (pre3Days -150kcal buffer, festivalDay +400kcal & +15g protein,
/// post1Day +1.0L water & -100kcal recovery), and satiety focus nudges.
library;

// ─────────────────────────────────────────────────────────────────────────────
// Domain Enums & Models
// ─────────────────────────────────────────────────────────────────────────────

/// Major Indian festivals supported by FitKarma (§P5-K & §P12-A Specifications).
enum FestivalType {
  diwali,
  holi,
  navratri,
  eid,
  karwaChauth,
  pongalOnam,
}

/// Relative day phase within a festival window.
enum FestivalDayRelative {
  /// 3 Days prior to festival day (Calorie banking buffer)
  pre3Days,

  /// 1 Day prior to festival day
  pre1Day,

  /// Main Festival Day
  festivalDay,

  /// 1 Day post festival day (Recovery & bloat flushing)
  post1Day,

  /// Outside active festival window
  none,
}

/// Data representation of an Indian festival event.
class FestivalEvent {
  const FestivalEvent({
    required this.name,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.description,
  });

  final String name;
  final FestivalType type;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
}

/// Baseline nutrition targets before festival adjustments.
class BaselineNutritionTargets {
  const BaselineNutritionTargets({
    this.calories = 2000,
    this.proteinG = 110,
    this.carbsG = 220,
    this.fatG = 65,
    this.waterL = 2.5,
  });

  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;
  final double waterL;
}

/// Adjusted targets payload output from [SmartFestivalNutritionEngine].
class FestivalAdjustedTargets {
  const FestivalAdjustedTargets({
    required this.adjustedCalories,
    required this.adjustedProteinG,
    required this.adjustedCarbsG,
    required this.adjustedFatG,
    required this.adjustedWaterL,
    required this.bannerMessage,
    required this.satietyNudge,
    required this.recommendedCardioMin,
    required this.relativeDay,
  });

  final int adjustedCalories;
  final int adjustedProteinG;
  final int adjustedCarbsG;
  final int adjustedFatG;
  final double adjustedWaterL;
  final String bannerMessage;
  final String satietyNudge;
  final int recommendedCardioMin;
  final FestivalDayRelative relativeDay;
}

// ─────────────────────────────────────────────────────────────────────────────
// Engine Implementation
// ─────────────────────────────────────────────────────────────────────────────

class SmartFestivalNutritionEngine {
  const SmartFestivalNutritionEngine();

  /// Seeded Indian festival calendar for 2026.
  static final List<FestivalEvent> festivalCalendar2026 = [
    FestivalEvent(
      name: 'Holi 🎨',
      type: FestivalType.holi,
      startDate: DateTime(2026, 3, 4),
      endDate: DateTime(2026, 3, 4),
      description: 'Festival of Colors! Gujiya & Thandai feasting expected.',
    ),
    FestivalEvent(
      name: 'Navratri Fasting 🕉️',
      type: FestivalType.navratri,
      startDate: DateTime(2026, 3, 19),
      endDate: DateTime(2026, 3, 27),
      description: '9 Days Fasting! Sattvic diet & grain restrictions.',
    ),
    FestivalEvent(
      name: 'Eid ul-Fitr 🌙',
      type: FestivalType.eid,
      startDate: DateTime(2026, 3, 20),
      endDate: DateTime(2026, 3, 21),
      description: 'Eid Celebrations! Sheer Khurma & Biryani feast.',
    ),
    FestivalEvent(
      name: 'Karwa Chauth 🌕',
      type: FestivalType.karwaChauth,
      startDate: DateTime(2026, 10, 28),
      endDate: DateTime(2026, 10, 28),
      description: 'Fasting from sunrise to moonrise.',
    ),
    FestivalEvent(
      name: 'Diwali 🪔',
      type: FestivalType.diwali,
      startDate: DateTime(2026, 11, 8),
      endDate: DateTime(2026, 11, 10),
      description: 'Festival of Lights! Indian sweets (Mithai) & celebration meals.',
    ),
  ];

  /// Detects active festival and relative day phase for a given date.
  (FestivalEvent?, FestivalDayRelative) detectFestival(DateTime targetDate, {List<FestivalEvent>? customCalendar}) {
    final calendar = customCalendar ?? festivalCalendar2026;
    final dateOnly = DateTime(targetDate.year, targetDate.month, targetDate.day);

    for (final event in calendar) {
      final startOnly = DateTime(event.startDate.year, event.startDate.month, event.startDate.day);
      final endOnly = DateTime(event.endDate.year, event.endDate.month, event.endDate.day);

      // Check if targetDate is exact festival day(s)
      if (dateOnly.isAfter(startOnly.subtract(const Duration(days: 1))) &&
          dateOnly.isBefore(endOnly.add(const Duration(days: 1)))) {
        return (event, FestivalDayRelative.festivalDay);
      }

      // Check pre3Days window (1-3 days prior to startDate)
      final pre3Start = startOnly.subtract(const Duration(days: 3));
      final pre1Day = startOnly.subtract(const Duration(days: 1));

      if (dateOnly == pre1Day) {
        return (event, FestivalDayRelative.pre1Day);
      }

      if (dateOnly.isAfter(pre3Start.subtract(const Duration(days: 1))) &&
          dateOnly.isBefore(startOnly)) {
        return (event, FestivalDayRelative.pre3Days);
      }

      // Check post1Day window (1 day after endDate)
      final post1Day = endOnly.add(const Duration(days: 1));
      if (dateOnly == post1Day) {
        return (event, FestivalDayRelative.post1Day);
      }
    }

    return (null, FestivalDayRelative.none);
  }

  /// Calculates pre-compensation and post-recovery target adjustments.
  FestivalAdjustedTargets adjustTargets({
    required BaselineNutritionTargets baseline,
    required FestivalEvent event,
    required FestivalDayRelative relativeDay,
  }) {
    switch (event.type) {
      case FestivalType.diwali:
        return _calculateDiwaliProtocol(baseline, relativeDay);
      case FestivalType.holi:
        return _calculateHoliProtocol(baseline, relativeDay);
      case FestivalType.navratri:
        return _calculateNavratriProtocol(baseline, relativeDay);
      case FestivalType.karwaChauth:
        return _calculateKarwaChauthProtocol(baseline, relativeDay);
      case FestivalType.eid:
      case FestivalType.pongalOnam:
        return _calculateGenericFestivalProtocol(baseline, event, relativeDay);
    }
  }

  FestivalAdjustedTargets _calculateDiwaliProtocol(BaselineNutritionTargets base, FestivalDayRelative phase) {
    switch (phase) {
      case FestivalDayRelative.pre3Days:
      case FestivalDayRelative.pre1Day:
        return FestivalAdjustedTargets(
          adjustedCalories: base.calories - 150, // Banking -150 kcal/day buffer
          adjustedProteinG: base.proteinG + 5,
          adjustedCarbsG: base.carbsG - 30,
          adjustedFatG: base.fatG - 5,
          adjustedWaterL: base.waterL + 0.5,
          bannerMessage: '🪔 Diwali Buffer Active (-150 kcal/day banked for festival sweets)',
          satietyNudge: 'Pre-diwali calorie banking in progress. Stay hydrated and prioritize protein.',
          recommendedCardioMin: 0,
          relativeDay: phase,
        );

      case FestivalDayRelative.festivalDay:
        return FestivalAdjustedTargets(
          adjustedCalories: base.calories + 400, // Sweets buffer
          adjustedProteinG: base.proteinG + 15,  // Early satiety
          adjustedCarbsG: base.carbsG + 60,
          adjustedFatG: base.fatG + 15,
          adjustedWaterL: base.waterL + 0.5,
          bannerMessage: '🪔 Happy Diwali! Calorie Target +400 kcal allocated for Mithai',
          satietyNudge: 'Diwali sweets expected today! Eat your high-protein sources (whey/paneer) first before indulging to blunt blood sugar spikes.',
          recommendedCardioMin: 0,
          relativeDay: phase,
        );

      case FestivalDayRelative.post1Day:
        return FestivalAdjustedTargets(
          adjustedCalories: base.calories - 100,
          adjustedProteinG: base.proteinG + 10,
          adjustedCarbsG: base.carbsG - 50,
          adjustedFatG: base.fatG - 10,
          adjustedWaterL: base.waterL + 1.0, // Flush sodium & bloat
          bannerMessage: '💧 Post-Diwali Hydration & Recovery Protocol Active (+1.0L Water)',
          satietyNudge: 'Flush out sodium & bloat today! Drink 3.5L water and take a 45-minute recovery walk.',
          recommendedCardioMin: 45,
          relativeDay: phase,
        );

      case FestivalDayRelative.none:
        return _unadjusted(base);
    }
  }

  FestivalAdjustedTargets _calculateHoliProtocol(BaselineNutritionTargets base, FestivalDayRelative phase) {
    if (phase == FestivalDayRelative.festivalDay) {
      return FestivalAdjustedTargets(
        adjustedCalories: base.calories + 350,
        adjustedProteinG: base.proteinG + 10,
        adjustedCarbsG: base.carbsG + 50,
        adjustedFatG: base.fatG + 10,
        adjustedWaterL: base.waterL + 1.0,
        bannerMessage: '🎨 Happy Holi! Hydration Target +1.0L for Outdoor Play & Gujiya Buffer',
        satietyNudge: 'Holi celebrations today! Drink plenty of water and enjoy Gujiya mindfully after your protein meal.',
        recommendedCardioMin: 0,
        relativeDay: phase,
      );
    } else if (phase == FestivalDayRelative.post1Day) {
      return FestivalAdjustedTargets(
        adjustedCalories: base.calories - 100,
        adjustedProteinG: base.proteinG,
        adjustedCarbsG: base.carbsG - 40,
        adjustedFatG: base.fatG - 5,
        adjustedWaterL: base.waterL + 1.0,
        bannerMessage: '💧 Post-Holi Hydration Flush Active (+1.0L Water)',
        satietyNudge: 'Rehydrate fully today and enjoy a steady recovery walk.',
        recommendedCardioMin: 30,
        relativeDay: phase,
      );
    }
    return _unadjusted(base);
  }

  FestivalAdjustedTargets _calculateNavratriProtocol(BaselineNutritionTargets base, FestivalDayRelative phase) {
    return FestivalAdjustedTargets(
      adjustedCalories: base.calories,
      adjustedProteinG: base.proteinG,
      adjustedCarbsG: base.carbsG + 30, // Sabudana / Potato carb shift
      adjustedFatG: base.fatG,
      adjustedWaterL: base.waterL + 0.5,
      bannerMessage: '🕉️ Navratri Fasting Mode Active (Sattvic & Dairy Protein Focus)',
      satietyNudge: 'Grains & legumes restricted. Rely on paneer, curd, samak rice, and peanuts to hit your protein targets.',
      recommendedCardioMin: 0,
      relativeDay: phase,
    );
  }

  FestivalAdjustedTargets _calculateKarwaChauthProtocol(BaselineNutritionTargets base, FestivalDayRelative phase) {
    if (phase == FestivalDayRelative.pre1Day) {
      return FestivalAdjustedTargets(
        adjustedCalories: base.calories + 100,
        adjustedProteinG: base.proteinG + 10,
        adjustedCarbsG: base.carbsG + 20,
        adjustedFatG: base.fatG,
        adjustedWaterL: base.waterL + 1.5,
        bannerMessage: '🌕 Karwa Chauth Sargi Buffer Active (+1.5L Water)',
        satietyNudge: 'Load up on complex carbs & hydration during Sargi to sustain energy throughout the fast.',
        recommendedCardioMin: 0,
        relativeDay: phase,
      );
    }
    return _unadjusted(base);
  }

  FestivalAdjustedTargets _calculateGenericFestivalProtocol(
    BaselineNutritionTargets base,
    FestivalEvent event,
    FestivalDayRelative phase,
  ) {
    if (phase == FestivalDayRelative.festivalDay) {
      return FestivalAdjustedTargets(
        adjustedCalories: base.calories + 300,
        adjustedProteinG: base.proteinG + 10,
        adjustedCarbsG: base.carbsG + 40,
        adjustedFatG: base.fatG + 10,
        adjustedWaterL: base.waterL + 0.5,
        bannerMessage: '🎉 ${event.name} Target Adjustment Active (+300 kcal)',
        satietyNudge: 'Enjoy the festival feast! Eat protein first to regulate satiety.',
        recommendedCardioMin: 0,
        relativeDay: phase,
      );
    }
    return _unadjusted(base);
  }

  FestivalAdjustedTargets _unadjusted(BaselineNutritionTargets base) {
    return FestivalAdjustedTargets(
      adjustedCalories: base.calories,
      adjustedProteinG: base.proteinG,
      adjustedCarbsG: base.carbsG,
      adjustedFatG: base.fatG,
      adjustedWaterL: base.waterL,
      bannerMessage: '',
      satietyNudge: '',
      recommendedCardioMin: 0,
      relativeDay: FestivalDayRelative.none,
    );
  }
}
