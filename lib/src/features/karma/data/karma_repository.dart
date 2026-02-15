import 'package:pocketbase/pocketbase.dart';
import '../domain/karma_transaction.dart';
import '../domain/karma_action.dart';

class KarmaRepository {
  final PocketBase pb;
  KarmaRepository(this.pb);

  /// Get all karma transactions for a user
  Future<List<KarmaTransaction>> getUserTransactions(String userId) async {
    final records = await pb.collection('karma_transactions').getList(
      filter: 'user = "$userId"',
      sort: '-date',
    );
    return records.items.map((record) => KarmaTransaction.fromJson(record.toJson())).toList();
  }

  /// Get karma transactions for a specific date range
  Future<List<KarmaTransaction>> getTransactionsInRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final records = await pb.collection('karma_transactions').getList(
      filter: 'user = "$userId" && date >= "${start.toIso8601String()}" && date <= "${end.toIso8601String()}"',
      sort: '-date',
    );
    return records.items.map((record) => KarmaTransaction.fromJson(record.toJson())).toList();
  }

  /// Get today's transactions for a user
  Future<List<KarmaTransaction>> getTodayTransactions(String userId) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getTransactionsInRange(userId, startOfDay, endOfDay);
  }

  /// Check if user has already earned karma for a specific action today
  Future<bool> hasEarnedActionToday(String userId, String actionType) async {
    final todayTransactions = await getTodayTransactions(userId);
    return todayTransactions.any((t) => t.actionType == actionType);
  }

  /// Add a karma transaction (earn karma)
  Future<KarmaTransaction> earnKarma({
    required String userId,
    required String actionType,
    String? description,
  }) async {
    final amount = KarmaAction.getKarmaValue(actionType);
    final displayName = KarmaAction.getDisplayName(actionType);
    
    final record = await pb.collection('karma_transactions').create(body: {
      'user': userId,
      'amount': amount,
      'action_type': actionType,
      'description': description ?? displayName,
      'date': DateTime.now().toIso8601String(),
    });

    // Update user's karma points in the users collection
    await _updateUserKarma(userId, amount);

    return KarmaTransaction.fromJson(record.toJson());
  }

  /// Spend karma (redeem for premium features)
  Future<KarmaTransaction> spendKarma({
    required String userId,
    required String actionType,
    String? description,
  }) async {
    final amount = KarmaAction.getKarmaValue(actionType);
    final displayName = KarmaAction.getDisplayName(actionType);
    
    // Get current karma balance
    final user = await pb.collection('users').getOne(userId);
    final currentKarma = user.data['karmaPoints'] as int? ?? 0;
    
    if (currentKarma < amount) {
      throw Exception('Insufficient karma points. Need $amount, have $currentKarma');
    }

    // Create transaction with negative amount
    final record = await pb.collection('karma_transactions').create(body: {
      'user': userId,
      'amount': -amount,
      'action_type': actionType,
      'description': description ?? displayName,
      'date': DateTime.now().toIso8601String(),
    });

    // Update user's karma points (subtract)
    await _updateUserKarma(userId, -amount);

    return KarmaTransaction.fromJson(record.toJson());
  }

  /// Update user's total karma points
  Future<void> _updateUserKarma(String userId, int delta) async {
    final user = await pb.collection('users').getOne(userId);
    final currentKarma = user.data['karmaPoints'] as int? ?? 0;
    final newKarma = currentKarma + delta;
    
    // Update karma tier based on new balance
    final newTier = _calculateKarmaTier(newKarma);
    
    await pb.collection('users').update(userId, body: {
      'karmaPoints': newKarma,
      'karmaTier': newTier,
    });
  }

  /// Calculate karma tier based on total points
  String _calculateKarmaTier(int points) {
    if (points >= 50000) return 'Diamond';
    if (points >= 15000) return 'Platinum';
    if (points >= 5000) return 'Gold';
    if (points >= 1000) return 'Silver';
    return 'Bronze';
  }

  /// Get user's current karma balance
  Future<int> getKarmaBalance(String userId) async {
    final user = await pb.collection('users').getOne(userId);
    return user.data['karmaPoints'] as int? ?? 0;
  }

  /// Get user's karma tier
  Future<String> getKarmaTier(String userId) async {
    final user = await pb.collection('users').getOne(userId);
    return user.data['karmaTier'] as String? ?? 'Bronze';
  }

  /// Check and award streak bonuses if applicable
  Future<KarmaTransaction?> checkStreakBonus(String userId, int currentStreak) async {
    if (currentStreak == 7) {
      return earnKarma(
        userId: userId,
        actionType: KarmaAction.streak7Days,
        description: '7-Day Streak Bonus! 🎉',
      );
    } else if (currentStreak == 30) {
      return earnKarma(
        userId: userId,
        actionType: KarmaAction.streak30Days,
        description: '30-Day Streak Bonus! 🏆',
      );
    }
    return null;
  }
}

// Note: karmaRepositoryProvider is defined in karma_controller.dart
