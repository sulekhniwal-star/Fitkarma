import 'package:pocketbase/pocketbase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/pocketbase/pocketbase_provider.dart';
import '../domain/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final PocketBase pb;
  AuthRepository(this.pb);

  Future<UserProfile?> signUp(String email, String password) async {
    try {
      await pb
          .collection('users')
          .create(
            body: {
              'email': email,
              'password': password,
              'passwordConfirm': password,
            },
          );
      final authData = await pb
          .collection('users')
          .authWithPassword(email, password);
      return UserProfile.fromJson(authData.record.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProfile(UserProfile profile) async {
    try {
      await pb.collection('users').update(profile.id, body: profile.toJson());
    } catch (e) {
      rethrow;
    }
  }

  UserProfile? get currentUser {
    if (pb.authStore.isValid) {
      final model = pb.authStore.record as RecordModel;
      return UserProfile.fromJson(model.toJson());
    }
    return null;
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(pocketBaseProvider));
}
