import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/karma_repository.dart';
import '../domain/karma_transaction.dart';
import '../domain/karma_action.dart';
import '../../auth/data/auth_repository.dart';
import '../../../core/pocketbase/pocketbase_provider.dart';

/// Provider for karma repository
final karmaRepositoryProvider = Provider<KarmaRepository>((ref) {
  final pb = ref.watch(pocketBaseProvider);
  return KarmaRepository(pb);
});

/// Provider for karma balance
final karmaBalanceProvider = FutureProvider<int>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final user = authRepo.currentUser;
  if (user == null) return 0;
  
  final repo = ref.watch(karmaRepositoryProvider);
  return repo.getKarmaBalance(user.id);
});

/// Provider for karma tier
final karmaTierProvider = FutureProvider<String>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final user = authRepo.currentUser;
  if (user == null) return 'Bronze';
  
  final repo = ref.watch(karmaRepositoryProvider);
  return repo.getKarmaTier(user.id);
});

/// Provider for karma history
final karmaHistoryProvider = FutureProvider<List<KarmaTransaction>>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final user = authRepo.currentUser;
  if (user == null) return [];
  
  final repo = ref.watch(karmaRepositoryProvider);
  return repo.getUserTransactions(user.id);
});

/// Provider for today's karma
final todayKarmaProvider = FutureProvider<List<KarmaTransaction>>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final user = authRepo.currentUser;
  if (user == null) return [];
  
  final repo = ref.watch(karmaRepositoryProvider);
  return repo.getTodayTransactions(user.id);
});

/// Class to handle karma operations
class KarmaActions {
  final Ref ref;
  
  KarmaActions(this.ref);
  
  /// Award karma for an action
  Future<void> awardKarma(String actionType, {String? description}) async {
    final authRepo = ref.read(authRepositoryProvider);
    final user = authRepo.currentUser;
    if (user == null) return;
    
    final repo = ref.read(karmaRepositoryProvider);
    final alreadyEarned = await repo.hasEarnedActionToday(user.id, actionType);
    
    if (!alreadyEarned || _isRepeatableAction(actionType)) {
      try {
        await repo.earnKarma(
          userId: user.id,
          actionType: actionType,
          description: description,
        );
        ref.invalidate(karmaBalanceProvider);
        ref.invalidate(karmaHistoryProvider);
        ref.invalidate(todayKarmaProvider);
      } catch (e) {
        // Handle silently
      }
    }
  }
  
  /// Spend karma for a premium feature
  Future<bool> spendKarma(String actionType, {String? description}) async {
    final authRepo = ref.read(authRepositoryProvider);
    final user = authRepo.currentUser;
    if (user == null) return false;
    
    final repo = ref.read(karmaRepositoryProvider);
    final balance = await repo.getKarmaBalance(user.id);
    final cost = KarmaAction.getKarmaValue(actionType);
    
    if (balance < cost) return false;
    
    try {
      await repo.spendKarma(
        userId: user.id,
        actionType: actionType,
        description: description,
      );
      ref.invalidate(karmaBalanceProvider);
      ref.invalidate(karmaHistoryProvider);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Check and award streak bonus
  Future<void> checkStreakBonus(int currentStreak) async {
    final authRepo = ref.read(authRepositoryProvider);
    final user = authRepo.currentUser;
    if (user == null) return;
    
    final repo = ref.read(karmaRepositoryProvider);
    final bonus = await repo.checkStreakBonus(user.id, currentStreak);
    
    if (bonus != null) {
      ref.invalidate(karmaBalanceProvider);
      ref.invalidate(karmaHistoryProvider);
      ref.invalidate(todayKarmaProvider);
    }
  }
  
  bool _isRepeatableAction(String actionType) {
    final repeatableActions = [
      KarmaAction.postToFeed,
      KarmaAction.commentOnPost,
      KarmaAction.helpInCommunity,
      KarmaAction.completeWorkout,
      KarmaAction.completeStepGoal,
      KarmaAction.logAllMeals,
      KarmaAction.drink8GlassesWater,
    ];
    return repeatableActions.contains(actionType);
  }
}

/// Provider for karma actions
final karmaActionsProvider = Provider<KarmaActions>((ref) {
  return KarmaActions(ref);
});

/// Helper class to easily award karma from anywhere in the app
class KarmaAwarder {
  static void dailyLogin(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.dailyLogin);
  }
  
  static void completeStepGoal(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.completeStepGoal);
  }
  
  static void logAllMeals(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.logAllMeals);
  }
  
  static void drink8GlassesWater(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.drink8GlassesWater);
  }
  
  static void completeWorkout(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.completeWorkout);
  }
  
  static void logWeight(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.logWeightWeekly);
  }
  
  static void postToFeed(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.postToFeed);
  }
  
  static void commentOnPost(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.commentOnPost);
  }
  
  static void completeOnboarding(WidgetRef ref) {
    ref.read(karmaActionsProvider).awardKarma(KarmaAction.completeOnboarding);
  }
}
