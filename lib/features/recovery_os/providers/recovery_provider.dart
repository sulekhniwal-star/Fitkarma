import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/recovery_repository.dart';
import '../domain/body_soreness_map.dart';

final recoveryRepositoryProvider = Provider<RecoveryRepository>((ref) {
  return RecoveryRepository();
});

class BodySorenessNotifier extends StateNotifier<AsyncValue<BodySorenessMap>> {
  final RecoveryRepository _repository;
  final String _uid;
  final String _date;

  BodySorenessNotifier({
    required RecoveryRepository repository,
    required String uid,
    required String date,
  })  : _repository = repository,
        _uid = uid,
        _date = date,
        super(const AsyncValue.loading()) {
    loadMap();
  }

  Future<void> loadMap() async {
    try {
      final map = await _repository.getDailySorenessMap(uid: _uid, dateStr: _date);
      state = AsyncValue.data(map);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMuscleSoreness(MuscleGroup muscle, SorenessLevel level) async {
    final current = state.value ?? BodySorenessMap.initial();
    final updatedStates = Map<MuscleGroup, SorenessLevel>.from(current.muscleStates);
    updatedStates[muscle] = level;

    final newMap = BodySorenessMap(muscleStates: updatedStates, loggedAt: DateTime.now());
    state = AsyncValue.data(newMap);

    await _repository.saveSorenessMap(uid: _uid, dateStr: _date, map: newMap);
  }
}

final bodySorenessProvider =
    StateNotifierProvider.autoDispose<BodySorenessNotifier, AsyncValue<BodySorenessMap>>((ref) {
  final repo = ref.watch(recoveryRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);
  final date = ref.watch(selectedDateProvider);

  return BodySorenessNotifier(repository: repo, uid: uid, date: date);
});
