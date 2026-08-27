import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/womens_health_repository.dart';
import '../domain/womens_health_engine.dart';

final womensHealthRepositoryProvider = Provider<WomensHealthRepository>((ref) {
  return WomensHealthRepository();
});

final womensHealthProfileProvider = FutureProvider.autoDispose<WomensHealthProfile>((ref) async {
  final repo = ref.watch(womensHealthRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);

  return await repo.getProfile(uid: uid);
});
