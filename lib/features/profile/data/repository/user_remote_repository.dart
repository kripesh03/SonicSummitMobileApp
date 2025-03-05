import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/profile/data/data_source/remote_data_source/user_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/entity/user_entity.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/repository/user_repository.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDataSource remoteDataSource;
  final TokenSharedPrefs tokenSharedPrefs;

  UserRemoteRepository({
    required this.remoteDataSource,
    required this.tokenSharedPrefs,
  });

  @override
  Future<Either<Failure, UserEntity>> getUser() async {
    try {
      final userIdResult = await tokenSharedPrefs.getUserId();
      
      return userIdResult.fold(
        (failure) => Left(failure), // If failed to get userId, return failure
        (userId) async {
          final user = await remoteDataSource.getUser(userId);
          return Right(user);
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
