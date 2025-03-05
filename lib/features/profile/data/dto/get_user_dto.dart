import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/profile/data/model/user_api_model.dart';

part 'get_user_dto.g.dart';

@JsonSerializable()
class GetUserDTO {
  final UserApiModel user; // Change "data" to "user"

  GetUserDTO({
    required this.user,
  });

  Map<String, dynamic> toJson() => _$GetUserDTOToJson(this);

  factory GetUserDTO.fromJson(Map<String, dynamic> json) {
    return GetUserDTO(
      user: UserApiModel.fromJson(json), // No longer looking for 'data'
    );
  }
}
