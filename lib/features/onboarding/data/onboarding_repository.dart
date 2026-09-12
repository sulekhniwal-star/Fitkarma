import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_sync_worker.dart';
import '../domain/models/onboarding_state.dart';

/// OnboardingRepository — Handles local persistence + offline outbox sync for Onboarding
class OnboardingRepository {
  final AppDatabase db;
  final OutboxSyncWorker syncWorker;
  final _uuid = const Uuid();

  OnboardingRepository({
    required this.db,
    required this.syncWorker,
  });

  Future<void> saveCompleteOnboarding({
    required String userId,
    required OnboardingState state,
  }) async {
    final now = DateTime.now();

    // 1. Save Profile Locally & Queue Outbox
    await db.into(db.localProfiles).insertOnConflictUpdate(
          LocalProfilesCompanion.insert(
            userId: userId,
            name: const Value('FitKarma User'),
            age: Value(state.age),
            gender: Value(state.gender.name),
            heightCm: Value(state.heightCm),
            weightKg: Value(state.weightKg),
            primaryGoal: Value(state.goal?.name ?? 'fatLoss'),
            updatedAt: Value(now),
          ),
        );

    await syncWorker.enqueueMutation(
      tableName: 'profiles',
      action: 'UPSERT',
      payload: {
        'user_id': userId,
        'age': state.age,
        'gender': state.gender.name,
        'height_cm': state.heightCm,
        'weight_kg': state.weightKg,
        'primary_goal': state.goal?.name ?? 'fat_loss',
        'activity_level': state.activityLevel.name,
        'dosha_type': state.doshaProfile?.dominantDosha.name,
        'is_onboarded': true,
        'updated_at': now.toIso8601String(),
      },
    );

    // 2. Save Dosha Score if assessed
    if (state.doshaProfile != null) {
      final doshaId = _uuid.v4();
      final dosha = state.doshaProfile!;

      await db.into(db.localDoshaScores).insert(
            LocalDoshaScoresCompanion.insert(
              id: doshaId,
              userId: userId,
              vataScore: dosha.vataScore,
              pittaScore: dosha.pittaScore,
              kaphaScore: dosha.kaphaScore,
              dominantDosha: dosha.dominantDosha.name,
              assessedAt: Value(now),
            ),
          );

      await syncWorker.enqueueMutation(
        tableName: 'dosha_scores',
        action: 'INSERT',
        payload: {
          'id': doshaId,
          'user_id': userId,
          'vata_score': dosha.vataScore,
          'pitta_score': dosha.pittaScore,
          'kapha_score': dosha.kaphaScore,
          'dominant_dosha': dosha.dominantDosha.name,
          'assessed_at': now.toIso8601String(),
        },
      );
    }

    // 3. Save Women's Health & Cycle Tracking if enabled
    if (state.enableWomensHealth && state.cycleProfile != null) {
      final cycle = state.cycleProfile!;

      await db.into(db.localCycleTracking).insertOnConflictUpdate(
            LocalCycleTrackingCompanion.insert(
              userId: userId,
              cycleLengthDays: cycle.cycleLengthDays,
              currentCycleDay: cycle.currentCycleDay,
              currentPhase: cycle.currentPhase.name,
              hasPcos: Value(cycle.hasPCOS),
              updatedAt: Value(now),
            ),
          );

      await syncWorker.enqueueMutation(
        tableName: 'cycle_tracking',
        action: 'UPSERT',
        payload: {
          'user_id': userId,
          'cycle_length_days': cycle.cycleLengthDays,
          'current_cycle_day': cycle.currentCycleDay,
          'current_phase': cycle.currentPhase.name,
          'has_pcos': cycle.hasPCOS,
          'updated_at': now.toIso8601String(),
        },
      );
    }
  }
}
