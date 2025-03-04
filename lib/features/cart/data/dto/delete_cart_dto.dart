import 'package:json_annotation/json_annotation.dart';

part 'delete_cart_dto.g.dart';

@JsonSerializable()
class DeleteCartDTO {
  final String userId;
  final String productId;

  DeleteCartDTO({
    required this.userId,
    required this.productId,
  });

  factory DeleteCartDTO.fromJson(Map<String, dynamic> json) =>
      _$DeleteCartDTOFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteCartDTOToJson(this);
}
