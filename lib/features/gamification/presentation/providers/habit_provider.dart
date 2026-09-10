import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/habit_automation_engine.dart';
import '../../domain/habit_models.dart';
import '../../domain/karma_models.dart';
import 'karma_provider.dart';

final habitProvider =
    StateNotifierProvider<HabitNotifier, HabitDailySummary>((ref) {
  return HabitNotifier(ref);
});

class HabitNotifier extends StateNotifier<HabitDailySummary> {
  final Ref _ref;

  HabitNotifier(this._ref) : super(_getInitialSummary());

  static HabitDailySummary _getInitialSummary() {
    final defaultHabits = [
      Habit(
        id: 'habit_ushapan',
        title: 'Ushapan (Warm Water + Jeera/Methi)',
        regionalTitle: 'उषापान (गुनगुना जल + जीरा/मेथी)',
        cueDescription: 'Immediately upon waking up before brushing',
        routineDescription:
            'Drink 500ml warm water with soaked methi/jeera seeds',
        rewardKarmaPoints: 30,
        timeSlot: HabitTimeSlot.morning,
        triggerSource: HabitTriggerSource.manual,
        isCompletedToday: true,
        streakDays: 14,
        totalCompletions: 42,
        history30Days: List.generate(30, (i) => i % 6 != 0),
        habitStrengthIndex: 86.4,
        automaticityTier: HabitAutomaticityTier.automatic,
      ),
      Habit(
        id: 'habit_sunlight_pranayama',
        title: 'Morning Sunlight & Anulom Vilom (10m)',
        regionalTitle: 'प्रातः सूर्य प्रकाश व प्राणायाम (१० मिनट)',
        cueDescription: 'Step outside within 30 mins of waking',
        routineDescription:
            '10 mins sunlight exposure + 5 mins Anulom Vilom breathing',
        rewardKarmaPoints: 40,
        timeSlot: HabitTimeSlot.morning,
        triggerSource: HabitTriggerSource.manual,
        isCompletedToday: true,
        streakDays: 8,
        totalCompletions: 24,
        history30Days: List.generate(30, (i) => i % 4 != 0),
        habitStrengthIndex: 78.2,
        automaticityTier: HabitAutomaticityTier.automatic,
      ),
      Habit(
        id: 'habit_protein_lunch',
        title: 'Balanced Protein Lunch (30g+ Protein)',
        regionalTitle: 'संतुलित प्रोटीन मध्याह्न भोजन (३० ग्रा+)',
        cueDescription: 'When sitting down for lunch at 1:00 PM',
        routineDescription: 'Include Paneer/Dal/Soya/Sprouts with raw salad',
        rewardKarmaPoints: 50,
        timeSlot: HabitTimeSlot.afternoon,
        triggerSource: HabitTriggerSource.mealLogger,
        isCompletedToday: false,
        streakDays: 5,
        totalCompletions: 19,
        history30Days: List.generate(30, (i) => i % 3 != 0),
        habitStrengthIndex: 64.5,
        automaticityTier: HabitAutomaticityTier.reinforcement,
      ),
      Habit(
        id: 'habit_shatpawali_post_lunch',
        title: 'Post-Lunch Shatpawali (500 Steps)',
        regionalTitle: 'दोपहर भोजनोपरांत शतपावली (५०० कदम)',
        cueDescription: '5 minutes after finishing lunch',
        routineDescription: 'Gentle stroll to avoid postprandial glucose spike',
        rewardKarmaPoints: 40,
        timeSlot: HabitTimeSlot.afternoon,
        triggerSource: HabitTriggerSource.stepSensor,
        isCompletedToday: false,
        streakDays: 4,
        totalCompletions: 16,
        history30Days: List.generate(30, (i) => i % 5 != 0),
        habitStrengthIndex: 58.0,
        automaticityTier: HabitAutomaticityTier.reinforcement,
      ),
      Habit(
        id: 'habit_evening_workout',
        title: 'Resistance Workout / Desi Baithak & Dand',
        regionalTitle: 'दैनिक व्यायाम / स्ट्रेंथ ट्रेनिंग सत्र',
        cueDescription: 'At 6:00 PM evening training window',
        routineDescription: 'Complete scheduled training program session',
        rewardKarmaPoints: 100,
        timeSlot: HabitTimeSlot.evening,
        triggerSource: HabitTriggerSource.workoutLogger,
        isCompletedToday: false,
        streakDays: 6,
        totalCompletions: 28,
        history30Days: List.generate(30, (i) => i % 4 != 0),
        habitStrengthIndex: 71.0,
        automaticityTier: HabitAutomaticityTier.reinforcement,
      ),
      Habit(
        id: 'habit_shatpawali_post_dinner',
        title: 'Post-Dinner Shatpawali (1000 Steps)',
        regionalTitle: 'रात्रि भोजनोपरांत शतपावली (१००० कदम)',
        cueDescription: '10 minutes after dinner',
        routineDescription: '1000 slow mindful steps to aid digestion',
        rewardKarmaPoints: 50,
        timeSlot: HabitTimeSlot.night,
        triggerSource: HabitTriggerSource.stepSensor,
        isCompletedToday: false,
        streakDays: 12,
        totalCompletions: 38,
        history30Days: List.generate(30, (i) => i % 7 != 0),
        habitStrengthIndex: 82.5,
        automaticityTier: HabitAutomaticityTier.automatic,
      ),
      Habit(
        id: 'habit_digital_curfew',
        title: 'Digital Curfew 45m Before Sleep',
        regionalTitle: 'सोने से ४५ मिनट पूर्व स्क्रीन बंद (डिजिटल कर्फ्यू)',
        cueDescription: 'At 10:15 PM alarm trigger',
        routineDescription:
            'Phone kept in other room, read book or dim lighting',
        rewardKarmaPoints: 40,
        timeSlot: HabitTimeSlot.night,
        triggerSource: HabitTriggerSource.manual,
        isCompletedToday: false,
        streakDays: 3,
        totalCompletions: 11,
        history30Days: List.generate(30, (i) => i % 3 == 0),
        habitStrengthIndex: 38.5,
        automaticityTier: HabitAutomaticityTier.formation,
      ),
    ];

    return HabitAutomationEngine.computeDailySummary(defaultHabits);
  }

  /// Toggles habit completion, recalculates metrics, and triggers Karma points award
  void toggleHabit(String habitId) {
    final updatedList = state.habits.map((h) {
      if (h.id == habitId) {
        final toggled = HabitAutomationEngine.toggleHabitState(h);

        // Award Karma if habit was newly checked as complete
        if (toggled.isCompletedToday && !h.isCompletedToday) {
          _ref.read(karmaProvider.notifier).recordKarmaAction(
                action: KarmaActionType.mindfulnessPranayama,
                isReadinessAligned: true,
              );
        }

        return toggled;
      }
      return h;
    }).toList();

    state = HabitAutomationEngine.computeDailySummary(updatedList);
  }
}
