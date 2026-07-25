/// §P12-B Life Events Engine Implementation
///
/// Handles life-event adaptations (wedding, injury, travel, deadline, new baby)
/// and wires logged events into Transformation Memory (§P12-B spec).
library;

import '../transformation/transformation_journey_engine.dart';
import '../transformation/transformation_memory_repository.dart';
import 'life_events_models.dart';

class LifeEventsEngine {
  const LifeEventsEngine();

  /// Generates cross-module program adaptation payload for a specific life event.
  LifeEventAdaptation adapt(LifeEventRecord event) {
    switch (event.eventType) {
      case LifeEventType.injury:
        final region = (event.eventData['injuredRegion'] as String?) ?? 'General Body';
        return LifeEventAdaptation(
          eventType: event.eventType,
          rpeCap: 5,
          restrictedExerciseTags: [region.toLowerCase(), 'heavy_compound', 'high_impact'],
          recoveryFirst: true,
          adaptationSummary: '🏥 Injury Mode Active ($region): RPE capped at 5. Exercises straining $region disabled.',
        );

      case LifeEventType.travelAbroad:
      case LifeEventType.travelDomestic:
        final destination = (event.eventData['destination'] as String?) ?? 'Travel';
        return LifeEventAdaptation(
          eventType: event.eventType,
          reducedWorkoutDurationMin: 20,
          workoutBrief: true,
          calorieAdjustment: 150, // Buffer for airport/dining meals
          adaptationSummary: '✈️ Travel Mode Active ($destination): Quick 20-min hotel/bodyweight workouts & +150 kcal flexibility buffer.',
        );

      case LifeEventType.officeDeadline:
      case LifeEventType.examSeason:
        return const LifeEventAdaptation(
          eventType: LifeEventType.officeDeadline,
          reducedWorkoutDurationMin: 20,
          workoutBrief: true,
          stressManagement: true,
          adaptationSummary: '💼 High-Stress / Deadline Mode: 20-min express workouts & guided evening 5-min decompression breathing.',
        );

      case LifeEventType.newBaby:
        return const LifeEventAdaptation(
          eventType: LifeEventType.newBaby,
          reducedWorkoutDurationMin: 15,
          sleepReadinessLowered: true,
          recoveryFirst: true,
          workoutBrief: true,
          adaptationSummary: '👶 New Baby Mode: Sleep readiness expectations relaxed. 15-min restorative home workouts enabled.',
        );

      case LifeEventType.wedding:
        final weddingDate = (event.eventData['weddingDate'] as String?) ?? 'Upcoming';
        return LifeEventAdaptation(
          eventType: LifeEventType.wedding,
          workoutBrief: false,
          stressManagement: true,
          adaptationSummary: '💍 Wedding Transformation Mode ($weddingDate): Hypertrophy & high-definition blueprint initialized!',
        );

      case LifeEventType.ramadan:
      case LifeEventType.shiftWork:
      case LifeEventType.nightShift:
      case LifeEventType.relocation:
      case LifeEventType.grief:
      case LifeEventType.illness:
        return LifeEventAdaptation(
          eventType: event.eventType,
          rpeCap: 6,
          recoveryFirst: true,
          adaptationSummary: '🌿 Adaptive Mode (${event.eventType.name}): Lowered intensity & recovery focus enabled.',
        );
    }
  }

  /// Wires logged life events directly into Transformation Memory (§P12-B spec).
  void wireIntoTransformationMemory(
    LifeEventRecord event,
    TransformationMemoryRepository memoryRepo,
  ) {
    final currentMemory = memoryRepo.memory;

    switch (event.eventType) {
      case LifeEventType.injury:
        final region = (event.eventData['injuredRegion'] as String?) ?? 'General Injury';
        final injuryNote = 'Injured $region logged on ${_formatDate(event.startDate)}';
        if (!currentMemory.injuries.contains(injuryNote)) {
          final updatedInjuries = List<String>.from(currentMemory.injuries)..add(injuryNote);
          memoryRepo.updateMemory(_copyWith(currentMemory, injuries: updatedInjuries));
        }
        break;

      case LifeEventType.wedding:
        final milestoneNote = '💍 Wedding Transformation Phase logged on ${_formatDate(event.startDate)}';
        if (!currentMemory.motivationTriggers.contains(milestoneNote)) {
          final updatedTriggers = List<String>.from(currentMemory.motivationTriggers)..add(milestoneNote);
          memoryRepo.updateMemory(_copyWith(currentMemory, motivationTriggers: updatedTriggers));
        }
        break;

      case LifeEventType.officeDeadline:
      case LifeEventType.examSeason:
        final struggleNote = 'High stress period (${event.eventType.name}) logged on ${_formatDate(event.startDate)}';
        if (!currentMemory.majorStruggles.contains(struggleNote)) {
          final updatedStruggles = List<String>.from(currentMemory.majorStruggles)..add(struggleNote);
          memoryRepo.updateMemory(_copyWith(currentMemory, majorStruggles: updatedStruggles));
        }
        break;

      case LifeEventType.travelAbroad:
      case LifeEventType.travelDomestic:
        final dest = (event.eventData['destination'] as String?) ?? 'Travel';
        final travelNote = '✈️ Travel adaptation ($dest) logged on ${_formatDate(event.startDate)}';
        if (!currentMemory.successPatterns.contains(travelNote)) {
          final updatedPatterns = List<String>.from(currentMemory.successPatterns)..add(travelNote);
          memoryRepo.updateMemory(_copyWith(currentMemory, successPatterns: updatedPatterns));
        }
        break;

      default:
        break;
    }
  }

  String _formatDate(DateTime dt) => dt.toLocal().toString().substring(0, 10);

  TransformationMemory _copyWith(
    TransformationMemory m, {
    List<String>? injuries,
    List<String>? motivationTriggers,
    List<String>? majorStruggles,
    List<String>? successPatterns,
  }) {
    return TransformationMemory(
      weightHistory: m.weightHistory,
      majorStruggles: majorStruggles ?? m.majorStruggles,
      injuries: injuries ?? m.injuries,
      successPatterns: successPatterns ?? m.successPatterns,
      motivationTriggers: motivationTriggers ?? m.motivationTriggers,
      quitAttempts: m.quitAttempts,
      primaryPersonality: m.primaryPersonality,
    );
  }
}
