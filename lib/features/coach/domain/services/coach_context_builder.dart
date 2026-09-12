import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/metabolism/services/metabolism_engine.dart';
import 'package:fitkarma/features/onboarding/domain/models/onboarding_state.dart';
import 'package:fitkarma/features/readiness_engine/domain/models/readiness_result.dart';

/// CoachContextBuilder — Aggregates multi-modal telemetry into privacy-safe AI prompt context
class CoachContextBuilder {
  const CoachContextBuilder();

  Map<String, dynamic> buildContextSnapshot({
    required LocalProfile profile,
    LocalDoshaScore? dosha,
    LocalCycleTrackingData? cycle,
    ReadinessResult? readiness,
    MetabolicProfile? metabolic,
    List<LocalSorenessLog> sorenessLogs = const [],
    ProgramBlueprint blueprint = ProgramBlueprint.hypertrophyAesthetics,
  }) {
    return {
      'user_meta': {
        'age': profile.age ?? 26,
        'gender': profile.gender ?? 'male',
        'height_cm': profile.heightCm ?? 172.0,
        'weight_kg': profile.weightKg ?? 70.0,
        'primary_goal': profile.primaryGoal ?? 'fat_loss',
        'program_blueprint': blueprint.name,
      },
      'ayurvedic_prakriti': {
        'dominant_dosha': dosha?.dominantDosha ?? 'pitta',
        'vata_score': dosha?.vataScore ?? 10,
        'pitta_score': dosha?.pittaScore ?? 20,
        'kapha_score': dosha?.kaphaScore ?? 10,
      },
      'womens_health': cycle != null
          ? {
              'is_enabled': true,
              'cycle_day': cycle.currentCycleDay,
              'cycle_phase': cycle.currentPhase,
              'has_pcos': cycle.hasPcos,
            }
          : {'is_enabled': false},
      'daily_readiness': readiness != null
          ? {
              'score': readiness.score,
              'confidence_tier': readiness.confidenceTier.name,
              'state': readiness.state.name,
              'sleep_debt_hours': readiness.sleepDebtHours,
              'strain_capacity_budget': readiness.strainCapacityBudget,
              'recovery_age': readiness.recoveryAgeYears,
            }
          : {'score': 75, 'state': 'steady'},
      'metabolic_targets': metabolic != null
          ? {
              'target_calories': metabolic.targetCalories,
              'protein_grams': metabolic.targetProteinGrams,
              'carbs_grams': metabolic.targetCarbsGrams,
              'fats_grams': metabolic.targetFatsGrams,
            }
          : {'target_calories': 2000, 'protein_grams': 120},
      'active_soreness_areas': sorenessLogs.map((s) => {
            'muscle': s.muscleGroup,
            'severity': s.severity,
          }).toList(),
    };
  }

  /// Format context into concise system prompt instructions
  String buildSystemPrompt(Map<String, dynamic> context) {
    final meta = context['user_meta'] as Map<String, dynamic>? ?? {};
    final dosha = context['ayurvedic_prakriti'] as Map<String, dynamic>? ?? {};
    final readiness = context['daily_readiness'] as Map<String, dynamic>? ?? {};
    final metabolic = context['metabolic_targets'] as Map<String, dynamic>? ?? {};
    final cycle = context['womens_health'] as Map<String, dynamic>? ?? {};

    return '''
You are FitKarma Coach — India's intelligent, culturally-attuned, evidence-based AI Health & Fitness Coach.
Tone: Empathetic, scientifically precise, encouraging, bilingual (Hinglish/Hindi/English natural blend when appropriate).

USER CONTEXT:
- Profile: ${meta['gender']}, ${meta['age']} yrs, ${meta['weight_kg']} kg, Goal: ${meta['primary_goal']}, Blueprint: ${meta['program_blueprint']}
- Ayurvedic Prakriti: ${dosha['dominant_dosha']} dominant
- Daily Readiness: Score ${readiness['score']}/100 (${readiness['state']}), Sleep Debt: ${readiness['sleep_debt_hours'] ?? 0}h, Strain Budget: ${readiness['strain_capacity_budget'] ?? 14}/21
- Daily Target: ${metabolic['target_calories']} kcal (Protein: ${metabolic['protein_grams']}g, Carbs: ${metabolic['carbs_grams']}g, Fats: ${metabolic['fats_grams']}g)
- Cycle Tracking: ${cycle['is_enabled'] == true ? "Day ${cycle['cycle_day']} (${cycle['cycle_phase']}), PCOS: ${cycle['has_pcos']}" : "Not active"}

CORE RULES:
1. Always respect Indian dietary patterns (vegetarian proteins: paneer, sattu, sprouted moong, dal, soy chunks).
2. If readiness < 60, gently advise reducing training volume/intensity and optimizing sleep/stress.
3. Keep responses structured, concise, and immediately actionable.
''';
  }
}
