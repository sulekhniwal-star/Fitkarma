import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/environmental_health_repository.dart';
import '../domain/environmental_health_engine.dart';

final environmentalHealthRepositoryProvider = Provider<EnvironmentalHealthRepository>((ref) {
  return EnvironmentalHealthRepository();
});

final environmentalHealthProvider = FutureProvider.autoDispose<EnvironmentalHealthSnapshot>((ref) async {
  final repo = ref.watch(environmentalHealthRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);

  return await repo.getEnvironmentalSnapshot(uid: uid);
});
