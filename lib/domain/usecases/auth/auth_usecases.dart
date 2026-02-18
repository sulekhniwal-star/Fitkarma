import 'package:dartz/dartz.dart';
import 'package:fit_karma/domain/entities/user_entity.dart';
import 'package:fit_karma/domain/repositories/auth_repository.dart';
import '../../../core/errors/failure.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute(String email, String password) {
    return repository.login(email: email, password: password);
  }
}

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute(
    String email,
    String password,
    String name,
  ) {
    return repository.register(email: email, password: password, name: name);
  }
}

class LogoutUseCase {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> execute() {
    return repository.logout();
  }
}

class CheckAuthUseCase {
  final AuthRepository repository;
  CheckAuthUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute() {
    return repository.getCurrentUser();
  }
}
