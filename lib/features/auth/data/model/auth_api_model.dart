import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart';

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String username;
  final String email;
  final String? profilePicture;
  final String bio;
  final String? password;

  const AuthApiModel({
    this.id,
    required this.username,
    required this.email,
    required this.profilePicture,
    required this.bio,
    required this.password,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: id,
      username: username,
      email: email,
      profilePicture: profilePicture,
      bio: bio,
      password: password ?? '',
    );
  }

  // From Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      username: entity.username,
      email: entity.email,
      profilePicture: entity.profilePicture,
      bio: entity.bio,
      password: entity.password,
    );
  }

  @override
  List<Object?> get props =>
      [id, username, email, profilePicture, bio, password];
}
