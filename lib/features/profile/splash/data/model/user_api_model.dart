import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/profile/splash/domain/entity/user_entity.dart';

part 'user_api_model.g.dart';

@JsonSerializable()
class UserApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String username;
  final String email;
  final String bio; // Added bio field
  final String profilePicture; // Assuming a profile picture URL

  const UserApiModel({
    required this.id,
    required this.username,
    required this.email,
    required this.bio,
    required this.profilePicture,
  });

  // From JSON
  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  // To JSON
  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  // Convert UserApiModel to UserEntity
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      username: username,
      email: email,
      bio: bio,
      profilePicture: profilePicture,
    );
  }

  @override
  List<Object?> get props => [id, username, email, bio, profilePicture];
}
