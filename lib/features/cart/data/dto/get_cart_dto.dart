import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/model/cart_api_model.dart';

part 'get_cart_dto.g.dart';

@JsonSerializable()
class GetCartDTO {
  final List<CartApiModel> data;

  GetCartDTO({
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetCartDTOToJson(this);

  factory GetCartDTO.fromJson(Map<String, dynamic> json) {
    return GetCartDTO(
      data: (json['items'] as List<dynamic>)
          .map((cartItem) => CartApiModel.fromJson(cartItem))
          .toList(),
    );
  }
}
