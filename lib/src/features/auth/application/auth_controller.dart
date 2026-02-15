import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/auth_repository.dart';
import '../domain/user_model.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserProfile?> build() {
    return ref.watch(authRepositoryProvider).currentUser;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final pb = ref.read(authRepositoryProvider);
      // For now, using the collection login
      final authData = await pb.pb
          .collection('users')
          .authWithPassword(email, password);
      return UserProfile.fromJson(authData.record.toJson());
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).signUp(email, password),
    );
  }

  Future<void> logout() async {
    ref.read(authRepositoryProvider).pb.authStore.clear();
    state = const AsyncData(null);
  }
}
