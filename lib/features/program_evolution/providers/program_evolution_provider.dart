import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/program_evolution_repository.dart';
import '../domain/program_evolution_engine.dart';

final programEvolutionRepositoryProvider = Provider<ProgramEvolutionRepository>((ref) {
  return ProgramEvolutionRepository();
});

final programEvolutionProvider = FutureProvider.autoDispose<ProgramEvolutionResult>((ref) async {
  final repo = ref.watch(programEvolutionRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);

  return await repo.getLatestEvolution(uid: uid);
});
