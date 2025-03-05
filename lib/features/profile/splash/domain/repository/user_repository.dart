import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/profile/splash/domain/entity/user_entity.dart';

abstract class IUserRepository {
  Future<Either<Failure, UserEntity>> getUser();
}
