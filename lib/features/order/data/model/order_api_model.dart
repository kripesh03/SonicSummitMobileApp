import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_item_entity.dart';

part 'order_api_model.g.dart';

@JsonSerializable()
class OrderApiModel {
  final String? id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final List<dynamic> productIds;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderApiModel({
    this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.productIds,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) =>
      _$OrderApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderApiModelToJson(this);

  OrderEntity toEntity() {
    return OrderEntity(
      orderId: id ?? '',
      userId: userId,
      email: email,
      items: productIds
          .map((product) => OrderItemEntity.fromApi(product))
          .toList(),
      totalAmount: totalPrice,
      status: 'pending',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static List<OrderEntity> toEntityList(List<OrderApiModel> models) =>
      models.map((model) => model.toEntity()).toList();
}
