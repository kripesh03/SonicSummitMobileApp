import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/order/data/model/order_api_model.dart';

part 'get_orders_by_user_id_dto.g.dart';

@JsonSerializable()
class GetOrdersByUserIdDTO {
  final List<OrderApiModel> orders;

  GetOrdersByUserIdDTO({required this.orders});

  factory GetOrdersByUserIdDTO.fromJson(Map<String, dynamic> json) =>
      _$GetOrdersByUserIdDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetOrdersByUserIdDTOToJson(this);
}
