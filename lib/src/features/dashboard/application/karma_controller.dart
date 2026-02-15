import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/application/auth_controller.dart';
import '../data/karma_repository.dart';
import '../domain/karma_transaction.dart';
import '../domain/karma_tier.dart';

part 'karma_controller.g.dart';

@riverpod
class KarmaController extends _$KarmaController {
  @override
  FutureOr<void> build() async {}

  Future<List<KarmaTransaction>> getHistory() async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return [];
    return ref.read(karmaRepositoryProvider).getTransactions(user.id);
  }

  Future<List<KarmaTier>> getTiers() async {
    return ref.read(karmaRepositoryProvider).getTiers();
  }

  Future<void> earnPoints(
    double amount,
    String type,
    String description,
  ) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(karmaRepositoryProvider)
          .addTransaction(
            userId: user.id,
            amount: amount,
            type: type,
            description: description,
          );
      // Refresh auth state to update points in UI
      ref.invalidate(authControllerProvider);
    });
  }
}
