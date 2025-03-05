import 'package:sonic_summit_mobile_app/features/profile/domain/entity/user_entity.dart';

abstract interface class IUserDataSource {
  Future<UserEntity> getUser();
}
