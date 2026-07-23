import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fitkarma/core/database/app_database.dart' as db_lib;
import 'package:fitkarma/core/sync/connectivity_service.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/onboarding/demographics_controller.dart';
import 'package:fitkarma/features/onboarding/diet_plan_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ──────────────────────────────────────────────────────────────────────────────
// DietPlanService  —  Groq call + deterministic fallback  (§P1-E)
// ──────────────────────────────────────────────────────────────────────────────

/// Describes the user profile needed to build the Groq prompt.
class DietPlanRequest {
  const DietPlanRequest({
    required this.userId,
    required this.age,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.activityLevel,
    required this.goals,
    required this.calorieTarget,
    required this.proteinTargetG,
    this.dietType = 'vegetarian',
  });

  final String userId;
  final int age;
  final Gender gender;
  final double weightKg;
  final double heightCm;
  final ActivityLevel activityLevel;
  final List<String> goals;
  final int calorieTarget;
  final int proteinTargetG;
  final String dietType;

  double get bmi {
    final hM = heightCm / 100;
    return weightKg / (hM * hM);
  }

  /// SHA-256 hash of the prompt parameters to use as the AI cache key.
  String get promptHash {
    final seed =
        'diet_plan:$userId:$age:${gender.name}:${weightKg.round()}:${heightCm.round()}:${activityLevel.name}:${goals.join(",")}:$calorieTarget:$proteinTargetG:$dietType';
    return sha256.convert(utf8.encode(seed)).toString();
  }
}

/// Handles generating the 7-day plan — via Groq (cloud) or deterministic
/// local fallback — and persisting to the Drift `diet_plans` table.
class DietPlanService {
  DietPlanService(this._db, this._checkOnline);

  final db_lib.AppDatabase _db;
  final Future<bool> Function() _checkOnline;

  /// Timeout after which we give up on Groq and serve the local fallback.
  static const _kTimeout = Duration(seconds: 8);

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Attempts to load from Drift cache first; if not found/expired, generates
  /// a new plan from Groq (or deterministic fallback) and caches it.
  Future<DietPlan> generate(DietPlanRequest req) async {
    // 1. Check Drift cache (valid for 7 days)
    final cached = await _db.getCachedDietPlan(req.userId);
    if (cached != null) {
      final rawJson = jsonDecode(cached.planJson) as Map<String, dynamic>;
      return DietPlan.fromJson(
        rawJson,
        calorieTarget: cached.calorieTarget,
        proteinTarget: cached.proteinTargetG,
        isAiGenerated: cached.isAiGenerated,
      );
    }

    // 2. Try Groq with timeout
    final isOnline = await _checkOnline();
    if (isOnline) {
      try {
        final plan = await _callGroq(req).timeout(_kTimeout);
        await _persist(req, plan);
        return plan;
      } on TimeoutException {
        // Fall through to local fallback
      } catch (_) {
        // Fall through to local fallback
      }
    }

    // 3. Deterministic local fallback
    final fallback = _buildFallback(req);
    await _persist(req, fallback);
    return fallback;
  }

  /// Force-regenerates (ignores cache). Used by the Regenerate button.
  Future<DietPlan> regenerate(DietPlanRequest req) async {
    // Delete existing cache entry so generate() skips the cache check
    await (_db.delete(
      _db.cachedDietPlans,
    )..where((t) => t.userId.equals(req.userId))).go();
    return generate(req);
  }

  // ── Private ────────────────────────────────────────────────────────────────

  Future<void> _persist(DietPlanRequest req, DietPlan plan) async {
    await _db.saveDietPlan(
      userId: req.userId,
      planJson: jsonEncode(plan.toJson()),
      calorieTarget: req.calorieTarget,
      proteinTargetG: req.proteinTargetG,
      isAiGenerated: plan.isAiGenerated,
    );
  }

  /// Simulates a Groq API call (returns structured mock JSON).
  /// In production: replace with actual http.post to the Azure Functions endpoint.
  Future<DietPlan> _callGroq(DietPlanRequest req) async {
    // Simulate 1-2 s network latency
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    // Build mock plan from the prompt — in production this is the real Groq response.
    final days = _weekDayNames.asMap().entries.map((entry) {
      final day = entry.value;
      return DietDay(
        day: day,
        meals: _mockMealsForDay(
          dayIndex: entry.key,
          calorieTarget: req.calorieTarget,
          proteinTarget: req.proteinTargetG,
          dietType: req.dietType,
        ),
      );
    }).toList();

    return DietPlan(
      days: days,
      dailyCalorieTarget: req.calorieTarget,
      dailyProteinTargetG: req.proteinTargetG,
      isAiGenerated: true,
    );
  }

  /// Deterministic offline-safe meal blueprint (no AI dependency).
  DietPlan _buildFallback(DietPlanRequest req) {
    final days = _weekDayNames.asMap().entries.map((entry) {
      return DietDay(
        day: entry.value,
        meals: _fallbackMealsForDay(
          dayIndex: entry.key,
          calorieTarget: req.calorieTarget,
          proteinTarget: req.proteinTargetG,
          dietType: req.dietType,
        ),
      );
    }).toList();

    return DietPlan(
      days: days,
      dailyCalorieTarget: req.calorieTarget,
      dailyProteinTargetG: req.proteinTargetG,
      isAiGenerated: false,
    );
  }

  static const _weekDayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  // ── Meal blueprints (AI mock variant) ─────────────────────────────────────

  List<DietMeal> _mockMealsForDay({
    required int dayIndex,
    required int calorieTarget,
    required int proteinTarget,
    required String dietType,
  }) {
    // Rotate through a curated list of authentic Indian meals
    final idx = dayIndex % _aiBreakfastOptions.length;
    return [
      _aiBreakfastOptions[idx],
      _aiLunchOptions[idx],
      _aiDinnerOptions[idx],
      _aiSnackOptions[idx],
    ];
  }

  List<DietMeal> _fallbackMealsForDay({
    required int dayIndex,
    required int calorieTarget,
    required int proteinTarget,
    required String dietType,
  }) {
    final idx = dayIndex % _fallbackBreakfastOptions.length;
    return [
      _fallbackBreakfastOptions[idx],
      _fallbackLunchOptions[idx],
      _fallbackDinnerOptions[idx],
      _fallbackSnackOptions[idx],
    ];
  }

  // ── Curated Indian meal banks ──────────────────────────────────────────────
  //   Each list has 7 entries (one per day).

  static const _aiBreakfastOptions = [
    DietMeal(
      name: 'Paneer Bhurji + 2 Multigrain Roti',
      mealType: 'breakfast',
      calories: 420,
      proteinG: 22,
      carbsG: 38,
      fatG: 14,
      tip: 'Use low-fat paneer to reduce saturated fat.',
    ),
    DietMeal(
      name: 'Moong Dal Chilla + Mint Chutney',
      mealType: 'breakfast',
      calories: 310,
      proteinG: 18,
      carbsG: 34,
      fatG: 6,
      tip: 'Add grated carrot inside for extra fibre.',
    ),
    DietMeal(
      name: 'Idli (3) + Sambar + Coconut Chutney',
      mealType: 'breakfast',
      calories: 290,
      proteinG: 10,
      carbsG: 52,
      fatG: 5,
      tip: 'Sambar provides plant protein from toor dal.',
    ),
    DietMeal(
      name: 'Besan Chilla + Curd',
      mealType: 'breakfast',
      calories: 360,
      proteinG: 20,
      carbsG: 30,
      fatG: 12,
      tip: 'Add ajwain seeds for better digestion.',
    ),
    DietMeal(
      name: 'Poha with Groundnuts + Banana',
      mealType: 'breakfast',
      calories: 350,
      proteinG: 9,
      carbsG: 58,
      fatG: 8,
      tip: 'Groundnuts boost protein and healthy fats.',
    ),
    DietMeal(
      name: 'Dalia (Broken Wheat Porridge) + Boiled Egg',
      mealType: 'breakfast',
      calories: 330,
      proteinG: 18,
      carbsG: 40,
      fatG: 8,
      tip: 'Cook with milk for extra protein density.',
    ),
    DietMeal(
      name: 'Upma + Tomato + Green Chilli',
      mealType: 'breakfast',
      calories: 280,
      proteinG: 8,
      carbsG: 45,
      fatG: 7,
      tip: 'Use semolina sparingly; add more veggies.',
    ),
  ];

  static const _aiLunchOptions = [
    DietMeal(
      name: 'Dal Tadka + Brown Rice + Salad',
      mealType: 'lunch',
      calories: 580,
      proteinG: 18,
      carbsG: 82,
      fatG: 8,
      tip: 'Brown rice has 3× the fibre of white rice.',
    ),
    DietMeal(
      name: 'Rajma Chawal + Onion Salad',
      mealType: 'lunch',
      calories: 620,
      proteinG: 24,
      carbsG: 90,
      fatG: 7,
      tip: 'Rajma is one of the best plant protein sources.',
    ),
    DietMeal(
      name: 'Chole + 2 Phulka + Raita',
      mealType: 'lunch',
      calories: 540,
      proteinG: 20,
      carbsG: 72,
      fatG: 10,
      tip: 'Use low-oil cooking; skip cream or ghee toppings.',
    ),
    DietMeal(
      name: 'Masoor Dal + Jeera Rice + Papad',
      mealType: 'lunch',
      calories: 490,
      proteinG: 16,
      carbsG: 76,
      fatG: 6,
      tip: 'Masoor dal has the highest iron among lentils.',
    ),
    DietMeal(
      name: 'Palak Paneer + 2 Roti',
      mealType: 'lunch',
      calories: 560,
      proteinG: 22,
      carbsG: 48,
      fatG: 18,
      tip: 'Add lemon juice after cooking to preserve iron.',
    ),
    DietMeal(
      name: 'Aloo Gobhi + 2 Roti + Dal',
      mealType: 'lunch',
      calories: 510,
      proteinG: 14,
      carbsG: 70,
      fatG: 9,
      tip: 'Cauliflower is high in choline, supporting liver health.',
    ),
    DietMeal(
      name: 'Khichdi + Kadhi + Pickle',
      mealType: 'lunch',
      calories: 470,
      proteinG: 16,
      carbsG: 68,
      fatG: 7,
      tip: 'Khichdi is easy to digest — great for recovery days.',
    ),
  ];

  static const _aiDinnerOptions = [
    DietMeal(
      name: 'Grilled Tandoori Chicken + Roti + Salad',
      mealType: 'dinner',
      calories: 480,
      proteinG: 42,
      carbsG: 30,
      fatG: 10,
      tip: 'Marinate in curd + turmeric for anti-inflammatory benefits.',
    ),
    DietMeal(
      name: 'Soya Bhurji + 2 Roti',
      mealType: 'dinner',
      calories: 400,
      proteinG: 30,
      carbsG: 38,
      fatG: 9,
      tip: 'Soya chunks provide complete protein at very low cost.',
    ),
    DietMeal(
      name: 'Dal Makhani (low-fat) + Brown Rice',
      mealType: 'dinner',
      calories: 520,
      proteinG: 20,
      carbsG: 70,
      fatG: 12,
      tip: 'Skip the cream; add cashew paste for a lighter version.',
    ),
    DietMeal(
      name: 'Mixed Veg Curry + 2 Roti',
      mealType: 'dinner',
      calories: 380,
      proteinG: 10,
      carbsG: 52,
      fatG: 8,
      tip: 'Higher vegetable variety = better micronutrient density.',
    ),
    DietMeal(
      name: 'Tofu Tikka Masala + Brown Rice',
      mealType: 'dinner',
      calories: 450,
      proteinG: 28,
      carbsG: 50,
      fatG: 11,
      tip: 'Tofu absorbs spice well — great protein for vegetarians.',
    ),
    DietMeal(
      name: 'Fish Curry (Rohu) + Steamed Rice',
      mealType: 'dinner',
      calories: 510,
      proteinG: 36,
      carbsG: 48,
      fatG: 10,
      tip: 'River fish is rich in omega-3 for brain and heart health.',
    ),
    DietMeal(
      name: 'Paneer Tikka + Dal Soup',
      mealType: 'dinner',
      calories: 420,
      proteinG: 26,
      carbsG: 28,
      fatG: 16,
      tip: 'Tikka reduces fat vs. a gravy version by ~30%.',
    ),
  ];

  static const _aiSnackOptions = [
    DietMeal(
      name: 'Roasted Chana + Green Tea',
      mealType: 'snack',
      calories: 150,
      proteinG: 8,
      carbsG: 22,
      fatG: 3,
      tip: 'Best pre-workout snack; high iron and fibre.',
    ),
    DietMeal(
      name: 'Makhana (Fox Nuts) + Almonds',
      mealType: 'snack',
      calories: 160,
      proteinG: 5,
      carbsG: 18,
      fatG: 7,
      tip: 'Makhana is low GI — ideal for sustained energy.',
    ),
    DietMeal(
      name: 'Banana + Peanut Butter (1 tbsp)',
      mealType: 'snack',
      calories: 200,
      proteinG: 5,
      carbsG: 32,
      fatG: 7,
      tip: 'Excellent post-workout recovery combo.',
    ),
    DietMeal(
      name: 'Curd + Honey + Walnuts',
      mealType: 'snack',
      calories: 180,
      proteinG: 6,
      carbsG: 20,
      fatG: 8,
      tip: 'Walnuts are the best plant source of omega-3.',
    ),
    DietMeal(
      name: 'Sprout Chaat + Lemon',
      mealType: 'snack',
      calories: 130,
      proteinG: 7,
      carbsG: 20,
      fatG: 1,
      tip: 'Sprouting increases protein bioavailability by 40%.',
    ),
    DietMeal(
      name: 'Coconut Water + Boiled Egg',
      mealType: 'snack',
      calories: 140,
      proteinG: 7,
      carbsG: 12,
      fatG: 5,
      tip: 'Natural electrolytes make coconut water ideal post-exercise.',
    ),
    DietMeal(
      name: 'Oats Smoothie + Chia Seeds',
      mealType: 'snack',
      calories: 210,
      proteinG: 8,
      carbsG: 30,
      fatG: 5,
      tip: 'Chia seeds absorb 12× their weight in water — keeps you full.',
    ),
  ];

  // ── Fallback meal banks (deterministic, offline-safe) ─────────────────────

  static const _fallbackBreakfastOptions = [
    DietMeal(
      name: 'Moong Dal Chilla (2) + Curd',
      mealType: 'breakfast',
      calories: 320,
      proteinG: 16,
      carbsG: 36,
      fatG: 7,
    ),
    DietMeal(
      name: 'Oats Porridge + Banana',
      mealType: 'breakfast',
      calories: 300,
      proteinG: 10,
      carbsG: 52,
      fatG: 5,
    ),
    DietMeal(
      name: 'Besan Chilla + Mint Chutney',
      mealType: 'breakfast',
      calories: 350,
      proteinG: 18,
      carbsG: 32,
      fatG: 10,
    ),
    DietMeal(
      name: 'Upma + Tomato Slice',
      mealType: 'breakfast',
      calories: 270,
      proteinG: 7,
      carbsG: 42,
      fatG: 6,
    ),
    DietMeal(
      name: 'Poha + Peanuts',
      mealType: 'breakfast',
      calories: 340,
      proteinG: 9,
      carbsG: 54,
      fatG: 8,
    ),
    DietMeal(
      name: 'Idli (2) + Sambar',
      mealType: 'breakfast',
      calories: 260,
      proteinG: 9,
      carbsG: 46,
      fatG: 4,
    ),
    DietMeal(
      name: 'Dalia + Jaggery',
      mealType: 'breakfast',
      calories: 310,
      proteinG: 8,
      carbsG: 56,
      fatG: 3,
    ),
  ];

  static const _fallbackLunchOptions = [
    DietMeal(
      name: 'Moong Dal + Jeera Rice + Salad',
      mealType: 'lunch',
      calories: 480,
      proteinG: 16,
      carbsG: 72,
      fatG: 5,
    ),
    DietMeal(
      name: 'Rajma + Brown Rice',
      mealType: 'lunch',
      calories: 550,
      proteinG: 22,
      carbsG: 82,
      fatG: 6,
    ),
    DietMeal(
      name: 'Chole + 2 Roti',
      mealType: 'lunch',
      calories: 510,
      proteinG: 18,
      carbsG: 70,
      fatG: 9,
    ),
    DietMeal(
      name: 'Kadhi + Steamed Rice',
      mealType: 'lunch',
      calories: 460,
      proteinG: 12,
      carbsG: 68,
      fatG: 8,
    ),
    DietMeal(
      name: 'Dal + 2 Roti + Sabzi',
      mealType: 'lunch',
      calories: 500,
      proteinG: 15,
      carbsG: 70,
      fatG: 9,
    ),
    DietMeal(
      name: 'Palak Dal + Brown Rice',
      mealType: 'lunch',
      calories: 490,
      proteinG: 17,
      carbsG: 68,
      fatG: 7,
    ),
    DietMeal(
      name: 'Khichdi + Pickle',
      mealType: 'lunch',
      calories: 450,
      proteinG: 14,
      carbsG: 64,
      fatG: 7,
    ),
  ];

  static const _fallbackDinnerOptions = [
    DietMeal(
      name: 'Dal + 2 Roti',
      mealType: 'dinner',
      calories: 380,
      proteinG: 13,
      carbsG: 54,
      fatG: 6,
    ),
    DietMeal(
      name: 'Soya Chunks Curry + Rice',
      mealType: 'dinner',
      calories: 420,
      proteinG: 28,
      carbsG: 44,
      fatG: 8,
    ),
    DietMeal(
      name: 'Mix Veg Sabzi + 2 Roti',
      mealType: 'dinner',
      calories: 360,
      proteinG: 9,
      carbsG: 50,
      fatG: 7,
    ),
    DietMeal(
      name: 'Paneer + Roti',
      mealType: 'dinner',
      calories: 400,
      proteinG: 22,
      carbsG: 34,
      fatG: 14,
    ),
    DietMeal(
      name: 'Dal Soup + 2 Roti',
      mealType: 'dinner',
      calories: 370,
      proteinG: 12,
      carbsG: 52,
      fatG: 5,
    ),
    DietMeal(
      name: 'Rajma + Brown Rice (small portion)',
      mealType: 'dinner',
      calories: 450,
      proteinG: 18,
      carbsG: 66,
      fatG: 5,
    ),
    DietMeal(
      name: 'Moong Dal + Jeera Rice',
      mealType: 'dinner',
      calories: 390,
      proteinG: 14,
      carbsG: 60,
      fatG: 5,
    ),
  ];

  static const _fallbackSnackOptions = [
    DietMeal(
      name: 'Roasted Chana',
      mealType: 'snack',
      calories: 130,
      proteinG: 7,
      carbsG: 20,
      fatG: 2,
    ),
    DietMeal(
      name: 'Fruit Chaat',
      mealType: 'snack',
      calories: 110,
      proteinG: 1,
      carbsG: 26,
      fatG: 1,
    ),
    DietMeal(
      name: 'Makhana',
      mealType: 'snack',
      calories: 140,
      proteinG: 4,
      carbsG: 22,
      fatG: 3,
    ),
    DietMeal(
      name: 'Banana',
      mealType: 'snack',
      calories: 100,
      proteinG: 1,
      carbsG: 26,
      fatG: 0,
    ),
    DietMeal(
      name: 'Almonds (15)',
      mealType: 'snack',
      calories: 150,
      proteinG: 5,
      carbsG: 5,
      fatG: 12,
    ),
    DietMeal(
      name: 'Curd',
      mealType: 'snack',
      calories: 100,
      proteinG: 5,
      carbsG: 8,
      fatG: 3,
    ),
    DietMeal(
      name: 'Sprout Salad',
      mealType: 'snack',
      calories: 120,
      proteinG: 6,
      carbsG: 18,
      fatG: 1,
    ),
  ];
}

// ──────────────────────────────────────────────────────────────────────────────
// DietPlanNotifier  —  AsyncNotifier that owns the screen state
// ──────────────────────────────────────────────────────────────────────────────

class DietPlanNotifier extends Notifier<DietPlanState> {
  @override
  DietPlanState build() => const DietPlanState();

  DietPlanService get _svc => DietPlanService(
    ref.read(databaseProvider),
    () async => ref.read(connectivityProvider),
  );

  /// Select a day tab.
  void selectDay(int index) => state = state.copyWith(selectedDayIndex: index);

  /// Initial load — called when the screen first appears.
  Future<void> load(DietPlanRequest request) async {
    if (state.isLoading) return;
    state = state.copyWith(status: DietPlanStatus.loading, errorMessage: null);
    try {
      final plan = await _svc.generate(request);
      state = state.copyWith(status: DietPlanStatus.loaded, plan: plan);
    } catch (e) {
      state = state.copyWith(
        status: DietPlanStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Regenerate — decrements the counter and force-refreshes.
  Future<void> regenerate(DietPlanRequest request) async {
    if (state.regeneratesLeft <= 0) return;
    state = state.copyWith(
      status: DietPlanStatus.loading,
      regeneratesLeft: state.regeneratesLeft - 1,
      errorMessage: null,
    );
    try {
      final plan = await _svc.regenerate(request);
      state = state.copyWith(status: DietPlanStatus.loaded, plan: plan);
    } catch (e) {
      state = state.copyWith(
        status: DietPlanStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

/// Provider for the Diet Plan Results screen state machine.
final dietPlanProvider = NotifierProvider<DietPlanNotifier, DietPlanState>(
  DietPlanNotifier.new,
);

// ──────────────────────────────────────────────────────────────────────────────
// Helper: build a DietPlanRequest from demographics state (used by the screen)
// ──────────────────────────────────────────────────────────────────────────────

/// Protein target: weight × 1.6 g/kg (moderate protein synthesis goal).
int computeProteinTarget(double weightKg) => (weightKg * 1.6).round();
