import 'package:pocketbase/pocketbase.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String name);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final PocketBase pb;

  AuthRemoteDataSourceImpl(this.pb);

  @override
  Future<UserModel> login(String email, String password) async {
    final authData = await pb
        .collection('users')
        .authWithPassword(email, password);
    return UserModel.fromJson(authData.record.toJson());
  }

  @override
  Future<UserModel> register(String email, String password, String name) async {
    final body = {
      "email": email,
      "password": password,
      "passwordConfirm": password,
      "name": name,
    };
    final record = await pb.collection('users').create(body: body);
    return UserModel.fromJson(record.toJson());
  }

  @override
  Future<void> logout() async {
    pb.authStore.clear();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    if (pb.authStore.isValid) {
      final record = await pb.collection('users').getOne(pb.authStore.model.id);
      return UserModel.fromJson(record.toJson());
    }
    return null;
  }
}
