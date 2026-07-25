/// §P12-C Wedding Transformation Mode — Program Generator & Phase Logic
///
/// Generates phase-specific programs (Foundation >90d, Peak Shred 30-90d, Final Taper <30d),
/// skin nutrition milestones, and target macros matching §P12-C specification.
library;

enum WeddingPhase {
  foundation, // 90+ Days: Hypertrophy & strength foundation
  peakShred, // 30–90 Days: Body composition shred & elevated protein
  finalTaper, // <30 Days: Skin glow, de-stress, anti-bloat hydration
}

class WeddingChecklistItem {
  const WeddingChecklistItem({
    required this.id,
    required this.title,
    required this.category,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String category; // 'Nutrition', 'Hydration', 'Skin', 'De-stress'
  final bool isCompleted;

  WeddingChecklistItem copyWith({bool? isCompleted}) => WeddingChecklistItem(
        id: id,
        title: title,
        category: category,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class WeddingProgramPlan {
  const WeddingProgramPlan({
    required this.weddingDate,
    required this.daysRemaining,
    required this.phase,
    required this.phaseName,
    required this.dailyCalorieTarget,
    required this.dailyProteinG,
    required this.dailyHydrationL,
    required this.skinGlowNutrients,
    required this.workoutFocus,
    required this.checklist,
  });

  final DateTime weddingDate;
  final int daysRemaining;
  final WeddingPhase phase;
  final String phaseName;
  final int dailyCalorieTarget;
  final int dailyProteinG;
  final double dailyHydrationL;
  final List<String> skinGlowNutrients;
  final String workoutFocus;
  final List<WeddingChecklistItem> checklist;
}

class WeddingProgramGenerator {
  const WeddingProgramGenerator();

  /// Generates dynamic Wedding Program Plan based on target date countdown.
  WeddingProgramPlan generatePlan({required DateTime weddingDate, DateTime? currentDate}) {
    final now = currentDate ?? DateTime.now();
    final todayOnly = DateTime(now.year, now.month, now.day);
    final targetOnly = DateTime(weddingDate.year, weddingDate.month, weddingDate.day);
    final daysLeft = targetOnly.difference(todayOnly).inDays.clamp(0, 365);

    WeddingPhase phase;
    String phaseName;
    int calories;
    int protein;
    double hydration;
    String workoutFocus;
    List<String> skinNutrients;

    if (daysLeft < 30) {
      phase = WeddingPhase.finalTaper;
      phaseName = 'Final Taper & Skin Glow Phase ✨';
      calories = 1900;
      protein = 100;
      hydration = 3.5; // High hydration for skin radiance & anti-bloat
      workoutFocus = 'Light Muscle Tone, De-stress Stretch & 3.5L Hydration';
      skinNutrients = const [
        'Vitamin C (Citrus & Berries)',
        'Collagen & Amino Support',
        'Almonds & Flaxseeds (Omega-3)',
        'Cucumber & Coconut Water',
      ];
    } else if (daysLeft < 90) {
      phase = WeddingPhase.peakShred;
      phaseName = 'Peak Shred Phase 🔥';
      calories = 1750; // Caloric deficit for body composition shred
      protein = 125; // Elevated protein to preserve lean tissue
      hydration = 3.0;
      workoutFocus = 'High-Definition Resistance Training & 25-min Cardio';
      skinNutrients = const [
        'Zinc & Antioxidants',
        'Green Tea Polyphenols',
        'Walnuts & Chia Seeds',
      ];
    } else {
      phase = WeddingPhase.foundation;
      phaseName = 'Strength & Foundation Phase 🏛️';
      calories = 2000;
      protein = 110;
      hydration = 3.0;
      workoutFocus = 'Progressive Compound Lifts & Posture Optimization';
      skinNutrients = const [
        'Multivitamin Balance',
        'Hydrating Foods',
      ];
    }

    final checklist = [
      const WeddingChecklistItem(
        id: 'chk_hyd',
        title: 'Drink target hydration (3.0L–3.5L)',
        category: 'Hydration',
      ),
      const WeddingChecklistItem(
        id: 'chk_skin',
        title: 'Consume Skin-Glow superfoods (Almonds/Vitamin C)',
        category: 'Skin',
      ),
      const WeddingChecklistItem(
        id: 'chk_stress',
        title: '5-min Wedding De-Stress Breathing Meditation',
        category: 'De-stress',
      ),
      WeddingChecklistItem(
        id: 'chk_wrk',
        title: 'Complete $workoutFocus',
        category: 'Workout',
      ),
    ];

    return WeddingProgramPlan(
      weddingDate: weddingDate,
      daysRemaining: daysLeft,
      phase: phase,
      phaseName: phaseName,
      dailyCalorieTarget: calories,
      dailyProteinG: protein,
      dailyHydrationL: hydration,
      skinGlowNutrients: skinNutrients,
      workoutFocus: workoutFocus,
      checklist: checklist,
    );
  }
}
