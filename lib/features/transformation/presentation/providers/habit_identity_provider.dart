import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/habit_identity_engine.dart';
import '../../domain/habit_identity_models.dart';

final habitIdentityProvider =
    StateNotifierProvider<HabitIdentityNotifier, HabitIdentityReport>((ref) {
  return HabitIdentityNotifier();
});

class HabitIdentityNotifier extends StateNotifier<HabitIdentityReport> {
  HabitIdentityNotifier() : super(_buildInitialReport());

  static HabitIdentityReport _buildInitialReport() {
    final recentVotes = [
      IdentityVoteRecord(
        id: 'vote_1',
        habitName: 'Post-Dinner 100-Step Shatpawali',
        regionalHabitName: 'रात्रि शतपावली अनुष्ठान',
        archetypeReinforced: IdentityArchetype.urbanPacesetter,
        votesCount: 1,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        reinforcementMessage: '+1 Vote cast for Mindful Metabolic Vitality',
        regionalReinforcementMessage: 'मेटाबॉलिक सजगता के पक्ष में +१ संकल्प मत',
      ),
      IdentityVoteRecord(
        id: 'vote_2',
        habitName: 'Barbell Deadlift & Desi Baithak Session',
        regionalHabitName: 'शक्ति संवर्धन व बैठक सत्र',
        archetypeReinforced: IdentityArchetype.kshatriyaAthlete,
        votesCount: 2,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        reinforcementMessage: '+2 Votes cast for Kshatriya Strength Identity',
        regionalReinforcementMessage: 'शारीरिक सामर्थ्य व शक्ति स्वरूप के पक्ष में +२ मत',
      ),
      IdentityVoteRecord(
        id: 'vote_3',
        habitName: '1.4g/kg Protein Target Hit with Sattu & Dal',
        regionalHabitName: 'सत्तू व दाल द्वारा प्रोटीन पूर्ति',
        archetypeReinforced: IdentityArchetype.kshatriyaAthlete,
        votesCount: 1,
        timestamp: DateTime.now().subtract(const Duration(hours: 14)),
        reinforcementMessage: '+1 Vote cast for Cellular Muscle Recovery',
        regionalReinforcementMessage: 'मांसपेशी पोषण व रिकवरी के पक्ष में +१ मत',
      ),
      IdentityVoteRecord(
        id: 'vote_4',
        habitName: '10-Minute Evening Nadi Shodhana Pranayama',
        regionalHabitName: 'संध्याकालीन नाड़ी शोधन प्राणायाम',
        archetypeReinforced: IdentityArchetype.dharmaYogi,
        votesCount: 1,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        reinforcementMessage: '+1 Vote cast for Parasympathetic Vagal Tone',
        regionalReinforcementMessage: 'मानसिक शांति व स्वायत्त तंत्रिका संतुलन के पक्ष में +१ मत',
      ),
    ];

    return HabitIdentityEngine.evaluateHabitIdentity(
      primaryArchetype: IdentityArchetype.kshatriyaAthlete,
      totalVotesCast: 148,
      activeStreakDays: 24,
      adherenceScore: 89.0,
      recentVotes: recentVotes,
    );
  }

  void switchArchetype(IdentityArchetype archetype) {
    state = HabitIdentityEngine.evaluateHabitIdentity(
      primaryArchetype: archetype,
      totalVotesCast: state.totalVotesCast,
      activeStreakDays: 24,
      adherenceScore: 89.0,
      recentVotes: state.recentVotes,
    );
  }

  void castIdentityVote(IdentityVoteRecord newVote) {
    final updatedVotes = [newVote, ...state.recentVotes];
    state = HabitIdentityEngine.evaluateHabitIdentity(
      primaryArchetype: state.primaryArchetype,
      totalVotesCast: state.totalVotesCast + newVote.votesCount,
      activeStreakDays: 24,
      adherenceScore: 89.0,
      recentVotes: updatedVotes,
    );
  }
}
