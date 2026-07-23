/// §P5-C Fix My Meal Controller
///
/// Riverpod AsyncNotifier that orchestrates the full Fix My Meal flow:
///   pickImage → analyzeImage → MealVisionService → MealAnalysisPipeline → result
library;

import 'dart:typed_data';

import 'package:fitkarma/core/ai/ai_cache.dart';
import 'package:fitkarma/core/sync/sync_worker.dart';
import 'package:fitkarma/features/food/food_controller.dart';
import 'package:fitkarma/features/food/meal_analysis_pipeline.dart';
import 'package:fitkarma/features/food/meal_parser.dart';
import 'package:fitkarma/features/food/meal_vision_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────

enum FixMyMealPhase { idle, analyzing, result, error }

class FixMyMealState {
  const FixMyMealState({
    this.phase = FixMyMealPhase.idle,
    this.selectedImageBytes,
    this.visionResponse,
    this.analysisResult,
    this.portionMultiplier = 1.0,
    this.selectedMealType = 'Lunch',
    this.errorMessage,
  });

  final FixMyMealPhase phase;
  final Uint8List? selectedImageBytes;
  final GroqVisionResponse? visionResponse;
  final MealAnalysisResult? analysisResult;
  final double portionMultiplier;
  final String selectedMealType;
  final String? errorMessage;

  FixMyMealState copyWith({
    FixMyMealPhase? phase,
    Uint8List? selectedImageBytes,
    GroqVisionResponse? visionResponse,
    MealAnalysisResult? analysisResult,
    double? portionMultiplier,
    String? selectedMealType,
    String? errorMessage,
  }) => FixMyMealState(
    phase: phase ?? this.phase,
    selectedImageBytes: selectedImageBytes ?? this.selectedImageBytes,
    visionResponse: visionResponse ?? this.visionResponse,
    analysisResult: analysisResult ?? this.analysisResult,
    portionMultiplier: portionMultiplier ?? this.portionMultiplier,
    selectedMealType: selectedMealType ?? this.selectedMealType,
    errorMessage: errorMessage ?? this.errorMessage,
  );

  /// Effective macros after applying [portionMultiplier].
  double get effectiveCalories =>
      (visionResponse?.totalCalories ?? 0) * portionMultiplier;
  double get effectiveProteinG =>
      (visionResponse?.proteinG ?? 0) * portionMultiplier;
  double get effectiveCarbsG =>
      (visionResponse?.carbsG ?? 0) * portionMultiplier;
  double get effectiveFatG => (visionResponse?.fatG ?? 0) * portionMultiplier;
}

// ─────────────────────────────────────────────────────────────────────────────
// Notifier
// ─────────────────────────────────────────────────────────────────────────────

class FixMyMealNotifier extends Notifier<FixMyMealState> {
  static const _userId = 'local_user';

  @override
  FixMyMealState build() => const FixMyMealState();

  /// Injects image bytes and triggers analysis.
  /// Called from the UI when the user picks a photo (camera or gallery).
  Future<void> pickImage(Uint8List bytes) async {
    state = state.copyWith(
      phase: FixMyMealPhase.analyzing,
      selectedImageBytes: bytes,
      visionResponse: null,
      analysisResult: null,
      errorMessage: null,
      portionMultiplier: 1.0,
    );
    await _analyzeImage(bytes);
  }

  /// Sets the portion multiplier and re-computes the analysis result.
  void setPortionMultiplier(double multiplier) {
    state = state.copyWith(portionMultiplier: multiplier);
  }

  /// Updates the meal type for logging.
  void setMealType(String mealType) {
    state = state.copyWith(selectedMealType: mealType);
  }

  /// Logs the detected meal (× portionMultiplier) into the food provider.
  void logMeal() {
    final vision = state.visionResponse;
    if (vision == null) return;

    final item = FoodItem(
      id: 'vision_${DateTime.now().millisecondsSinceEpoch}',
      name: vision.detectedMeal,
      calories: (vision.totalCalories * state.portionMultiplier).round(),
      protein: (vision.proteinG * state.portionMultiplier).round(),
      carbs: (vision.carbsG * state.portionMultiplier).round(),
      fat: (vision.fatG * state.portionMultiplier).round(),
      mealType: state.selectedMealType,
    );

    ref.read(foodProvider.notifier).addFood(item);

    // Reset to idle after logging
    state = const FixMyMealState();
  }

  /// Resets state to idle so the user can re-analyze.
  void reset() {
    state = const FixMyMealState();
  }

  // ── Private ──────────────────────────────────────────────────────────────

  Future<void> _analyzeImage(Uint8List bytes) async {
    try {
      final db = ref.read(databaseProvider);
      final cache = AICache(db);
      final visionService = MealVisionService(cache);

      // Run the three-tier vision pipeline
      final visionResponse = await visionService.analyzePhoto(
        imageBytes: bytes,
        userId: _userId,
      );

      // Pipe through MealAnalysisPipeline for quality/readiness/goal scoring
      final catalog = _buildCatalogFromVision(visionResponse);
      const pipeline = MealAnalysisPipeline();
      final analysisResult = pipeline.analyze(
        rawText: visionResponse.detectedMeal.toLowerCase(),
        userGoal: UserGoal.generalHealth,
        catalog: catalog,
      );

      state = state.copyWith(
        phase: FixMyMealPhase.result,
        visionResponse: visionResponse,
        analysisResult: analysisResult,
      );
    } catch (e) {
      state = state.copyWith(
        phase: FixMyMealPhase.error,
        errorMessage: 'Analysis failed: ${e.toString()}',
      );
    }
  }

  /// Builds a single-item catalog from the vision response so the pipeline
  /// can compute quality scores on it without a database round-trip.
  List<FoodCatalogEntry> _buildCatalogFromVision(GroqVisionResponse v) {
    return [
      FoodCatalogEntry(
        id: 'vision_item',
        foodName: v.detectedMeal.toLowerCase(),
        calories: v.totalCalories,
        proteinG: v.proteinG,
        carbsG: v.carbsG,
        fatG: v.fatG,
        fiberG: v.fiberG,
        glycemicIndex: v.glycemicIndex,
        satietyIndex: 70, // neutral default
        searchTerms: v.detectedMeal.toLowerCase().split(RegExp(r'[\s+,]+')),
      ),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Provider
// ─────────────────────────────────────────────────────────────────────────────

final fixMyMealProvider = NotifierProvider<FixMyMealNotifier, FixMyMealState>(
  FixMyMealNotifier.new,
);
