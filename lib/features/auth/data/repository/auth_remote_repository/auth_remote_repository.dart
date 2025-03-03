import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/repository/auth_repository.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRemoteRepository(this._authRemoteDataSource);

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity User) async {
    try {
      await _authRemoteDataSource.registerUser(User);
      return Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

@override
Future<Either<Failure, String>> loginUser(String username, String password) async {
  try {
    final response = await _authRemoteDataSource.loginUser(username, password);
    return Right(response); // Return the full response instead of just the token
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}


  @override
  Future<Either<Failure, String>> uploadProfilePicture(File file) async {
    try {
      final imageName = await _authRemoteDataSource.uploadProfilePicture(file);
      return Right(imageName);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
