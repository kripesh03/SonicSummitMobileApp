import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/app/usecase/usecase.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String username;
  final String password;

  const LoginParams({
    required this.username,
    required this.password,
  });

  // Initial Constructor
  const LoginParams.initial()
      : username = '',
        password = '';

  @override
  List<Object> get props => [username, password];
}

class LoginUseCase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository repository;
  final TokenSharedPrefs tokenSharedPrefs;

  LoginUseCase(this.repository, this.tokenSharedPrefs);

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return repository.loginUser(params.username, params.password).then((result) {
      return result.fold(
        (failure) => Left(failure),
        (response) async {
          // Extract token and userId from the API response
          final Map<String, dynamic> decodedResponse = jsonDecode(response);
          final token = decodedResponse['token'];
          final userId = decodedResponse['userId'];

          // Save them in shared preferences
          await tokenSharedPrefs.saveAuthData(token, userId);

          return Right(token);
        },
      );
    });
  }
}
