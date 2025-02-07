
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/use_case/register_user_usecase.dart';

import 'auth_repo.mock.dart';

void main() {
  late AuthRepoMock repository;
  late RegisterUseCase usecase;

  setUp(() {
    repository = AuthRepoMock();
    usecase = RegisterUseCase(repository);
    registerFallbackValue(AuthEntity(
      email: 'John',
      bio: 'Doe',
      profilePicture: 'image_url',
      username: 'johndoe',
      password: 'password123',
    ));
  });

  group('RegisterUseCase Tests', () {
    const params = RegisterUserParams(
      email: 'John',
      bio: 'Doe',
      profilePicture: 'image_url',
      username: 'johndoe',
      password: 'password123',
    );

    test('should register user successfully', () async {
      when(() => repository.registerUser(any())).thenAnswer(
        (_) async => const Right(null),
      );

      final result = await usecase(params);

      expect(result, const Right(null));
      verify(() => repository.registerUser(any())).called(1);
      verifyNoMoreInteractions(repository);
    });

    test('should return ApiFailure when user registration fails', () async {
      final failure = ApiFailure(message: "Registration failed");
      when(() => repository.registerUser(any())).thenAnswer(
        (_) async => Left(failure),
      );

      final result = await usecase(params);

      expect(result, Left(failure));

      verify(() => repository.registerUser(any())).called(1);
      verifyNoMoreInteractions(repository);
    });
  });
}
