import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sonic_summit_mobile_app/app/constants/hive_table_constant.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String? profilePicture;
  @HiveField(4)
  final String bio;
  @HiveField(7)
  final String password;

  AuthHiveModel({
    String? userId,
    required this.username,
    required this.email,
    this.profilePicture,
    required this.bio,
    required this.password,
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const AuthHiveModel.initial()
      : userId = '',
        username = '',
        email = '',
        profilePicture = '',
        bio = '',
        password = '';

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      username: entity.username,
      email: entity.email,
      profilePicture: entity.profilePicture,
      bio: entity.bio,
      password: entity.password,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      username: username,
      email: email,
      profilePicture: profilePicture,
      bio: bio,
      password: password,
    );
  }

  @override
  List<Object?> get props =>
      [userId, username, email, profilePicture, bio, password];
}
