import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../health_os/providers/health_os_provider.dart';
import '../data/daily_mission_repository.dart';
import '../domain/daily_mission.dart';

final dailyMissionRepositoryProvider = Provider<DailyMissionRepository>((ref) {
  return DailyMissionRepository();
});

class DailyMissionNotifier extends StateNotifier<AsyncValue<List<DailyMissionItem>>> {
  final DailyMissionRepository _repository;
  final String _uid;
  final String _date;

  DailyMissionNotifier({
    required DailyMissionRepository repository,
    required String uid,
    required String date,
  })  : _repository = repository,
        _uid = uid,
        _date = date,
        super(const AsyncValue.loading()) {
    loadMissions();
  }

  Future<void> loadMissions() async {
    try {
      final list = await _repository.getDailyMissions(uid: _uid, dateStr: _date);
      state = AsyncValue.data(list);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleMission(String missionId) async {
    final currentList = state.value;
    if (currentList == null) return;

    final updated = currentList.map((item) {
      if (item.id == missionId) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return item;
    }).toList();

    state = AsyncValue.data(updated);
    await _repository.saveMissions(uid: _uid, dateStr: _date, missions: updated);
  }
}

final dailyMissionsProvider =
    StateNotifierProvider.autoDispose<DailyMissionNotifier, AsyncValue<List<DailyMissionItem>>>((ref) {
  final repo = ref.watch(dailyMissionRepositoryProvider);
  final uid = ref.watch(currentUserIdProvider);
  final date = ref.watch(selectedDateProvider);

  return DailyMissionNotifier(repository: repo, uid: uid, date: date);
});
