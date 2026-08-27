import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/metabolism_repository.dart';
import '../domain/adaptive_metabolism_engine.dart';

final metabolismRepositoryProvider = Provider<MetabolismRepository>((ref) {
  return MetabolismRepository();
});

final metabolismProfileProvider = FutureProvider.autoDispose<AdaptiveMetabolismProfile>((ref) async {
  final repo = ref.watch(metabolismRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);

  return await repo.getMetabolismProfile(uid: uid);
});
