import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/pocketbase/pocketbase_provider.dart';
import '../domain/karma_transaction.dart';
import '../domain/karma_tier.dart';

part 'karma_repository.g.dart';

class KarmaRepository {
  final PocketBase pb;
  KarmaRepository(this.pb);

  Future<List<KarmaTransaction>> getTransactions(String userId) async {
    final records = await pb
        .collection('karma_transactions')
        .getFullList(filter: 'user = "$userId"', sort: '-date');
    return records
        .map((record) => KarmaTransaction.fromJson(record.toJson()))
        .toList();
  }

  Future<List<KarmaTier>> getTiers() async {
    final records = await pb
        .collection('karma_tiers_config')
        .getFullList(sort: 'min_points');
    return records
        .map((record) => KarmaTier.fromJson(record.toJson()))
        .toList();
  }

  Future<void> addTransaction({
    required String userId,
    required double amount,
    required String type,
    required String description,
  }) async {
    await pb
        .collection('karma_transactions')
        .create(
          body: {
            'user': userId,
            'amount': amount,
            'action_type': type,
            'description': description,
            'date': DateTime.now().toUtc().toIso8601String(),
          },
        );

    // Also update the user's total karma points
    final userRecord = await pb.collection('users').getOne(userId);
    final currentPoints = userRecord.getIntValue('karma_points');
    await pb
        .collection('users')
        .update(userId, body: {'karma_points': currentPoints + amount.toInt()});
  }
}

@Riverpod(keepAlive: true)
KarmaRepository karmaRepository(Ref ref) {
  return KarmaRepository(ref.watch(pocketBaseProvider));
}
