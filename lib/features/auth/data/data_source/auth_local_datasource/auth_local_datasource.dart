import 'dart:io';
import 'package:sonic_summit_mobile_app/core/network/hive_service.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/data_source/auth_data_source.dart';
import 'package:sonic_summit_mobile_app/features/auth/data/model/auth_hive_model.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource(this._hiveService);

  @override
  Future<AuthEntity> getCurrentUser() {
    // Return Empty AuthEntity
    return Future.value(const AuthEntity(
      userId: "1",
      username: "",
      email: "",
      profilePicture: null,
      bio: "",
      password: "",
    ));
  }

  @override
  Future<String> loginUser (String username, String password) async {
    try {
      await _hiveService.login(username, password);
      return Future.value("Success");
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      // Convert AuthEntity to AuthHiveModel
      final authHiveModel = AuthHiveModel.fromEntity(user);

      await _hiveService.register(authHiveModel);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  Future<String> uploadProfilePicture(File file) {
    throw UnimplementedError();
  }
  
  @override
  Future<String> loginStudent(String username, String password) {
    // TODO: implement loginStudent
    throw UnimplementedError();
  }
  
  @override
  Future<void> registerStudent(AuthEntity student) {
    // TODO: implement registerStudent
    throw UnimplementedError();
  }
  
}
