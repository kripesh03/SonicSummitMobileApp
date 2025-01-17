import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sonic_summit_mobile_app/app/usecase/usecase.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String username;
  final String email;
  final String role;
  final String bio;
  final String password;

  const RegisterUserParams({
    required this.username,
    required this.email,
    required this.role,
    required this.bio,
    required this.password,
  });

  //intial constructor
  const RegisterUserParams.initial({
    required this.username,
    required this.email,
    required this.role,
    required this.bio,
    required this.password,
  });

  @override
  List<Object?> get props =>
      [username, email, role, bio, password];
}

class RegisterUseCase implements UsecaseWithParams<void, RegisterUserParams> {
  final IAuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final authEntity = AuthEntity(
      username: params.username,
      email: params.email,
      bio: params.bio,
      role: params.role,
      password: params.password,
    );
    return repository.registerUser(authEntity);
  }
}
