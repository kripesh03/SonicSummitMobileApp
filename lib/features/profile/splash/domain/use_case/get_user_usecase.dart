import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/profile/splash/domain/entity/user_entity.dart';
import 'package:sonic_summit_mobile_app/features/profile/splash/domain/repository/user_repository.dart';

class GetUserUseCase {
  final IUserRepository userRepository;

  GetUserUseCase({required this.userRepository});

  Future<Either<Failure, UserEntity>> call(String userId) async {
    return await userRepository.getUser();  // Returns the UserEntity
  }
}
