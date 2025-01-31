import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sonic_summit_mobile_app/app/usecase/usecase.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String username;
  final String email;
  final String bio;
  final String password;
  final String? profilePicture;


  const RegisterUserParams({
    required this.username,
    required this.email,
    required this.bio,
    required this.password,
        this.profilePicture,

  });

  const RegisterUserParams.initial({
    required this.username,
    required this.email,
    required this.bio,
    required this.password,
    this.profilePicture
  });

  @override
  List<Object?> get props =>
      [username, email, bio, password];
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
      password: params.password,
      profilePicture: params.profilePicture,

    );
    return repository.registerUser(authEntity);
  }
}
