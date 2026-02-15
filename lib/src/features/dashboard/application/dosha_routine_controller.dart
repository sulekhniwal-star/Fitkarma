import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/application/auth_controller.dart';
import '../../onboarding/data/dosha_repository.dart';

part 'dosha_routine_controller.g.dart';

@riverpod
class DoshaRoutineController extends _$DoshaRoutineController {
  @override
  FutureOr<List<Map<String, dynamic>>> build() async {
    final user = ref.watch(authControllerProvider).value;
    final dosha = user?.dosha;

    if (dosha == null || dosha.isEmpty) {
      return [];
    }

    final repo = ref.read(doshaRepositoryProvider);
    return repo.getRoutines(dosha.toLowerCase());
  }
}
