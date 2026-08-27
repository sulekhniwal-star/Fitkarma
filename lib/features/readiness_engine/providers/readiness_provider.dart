import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/readiness_repository.dart';
import '../domain/readiness_engine.dart';

final readinessRepositoryProvider = Provider<ReadinessRepository>((ref) {
  return ReadinessRepository();
});

final dailyReadinessProvider = FutureProvider.autoDispose<ReadinessEvaluationResult>((ref) async {
  final repo = ref.watch(readinessRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);
  final date = ref.watch(selectedDateProvider);

  return await repo.getDailyReadiness(uid: uid, dateStr: date);
});
