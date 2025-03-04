import 'package:json_annotation/json_annotation.dart';

part 'add_cart_dto.g.dart';

@JsonSerializable()
class AddCartDTO {
  final String userId;
  final String productId;

  AddCartDTO({
    required this.userId,
    required this.productId,
  });

  factory AddCartDTO.fromJson(Map<String, dynamic> json) => _$AddCartDTOFromJson(json);

  Map<String, dynamic> toJson() => _$AddCartDTOToJson(this);
}
