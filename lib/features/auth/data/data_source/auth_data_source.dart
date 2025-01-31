import 'dart:io';

import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';


abstract interface class IAuthDataSource {
  Future<String> loginUser(String username, String password);

  Future<void> registerUser(AuthEntity student);

  Future<AuthEntity> getCurrentUser();

  Future<String> uploadProfilePicture(File file);
}
