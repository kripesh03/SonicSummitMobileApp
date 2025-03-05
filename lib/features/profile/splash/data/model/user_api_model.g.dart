// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// ************************************************************************** 
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) =>
    UserApiModel(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,  // Updated field
      bio: json['bio'] as String,
      profilePicture: json['profilePicture'] as String,
    );

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'email': instance.email,  // Updated field
      'bio': instance.bio,
      'profilePicture': instance.profilePicture,
    };
