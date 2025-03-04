import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_item_entity.dart';

part 'order_api_model.g.dart';

@JsonSerializable()
class OrderApiModel {
  final String? id; // Nullable field
  final String userId;
  final String? name; // Nullable field
  final String? email; // Nullable field
  final String phone; // Ensuring phone is always a string
  final List<dynamic> productIds;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderApiModel({
    this.id,
    required this.userId,
    this.name,
    this.email,
    required this.phone,
    required this.productIds,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderApiModel.fromJson(Map<String, dynamic> json) {
    // Debugging: Print the raw JSON data being parsed
    print("Parsing OrderApiModel from JSON: $json");

    // Handle null or missing fields and ensure phone is a string
    final phone = json['phone'] != null ? json['phone'].toString() : ''; // Convert to String if it's a number

    // Convert MongoDB $numberDecimal to double
    json['totalPrice'] = json['totalPrice'] is double
        ? json['totalPrice']
        : double.tryParse(json['totalPrice'].toString()) ?? 0.0;

    // Convert productIds into a list of dynamic objects
    final products = (json['productIds'] as List<dynamic>).map((productJson) {
      return productJson; // Handle your product-specific data parsing here
    }).toList();

    try {
      final orderApiModel = _$OrderApiModelFromJson(json);
      print("Successfully parsed OrderApiModel: $orderApiModel");
      return orderApiModel;
    } catch (e) {
      print("Error parsing OrderApiModel: $e");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    print("Converting OrderApiModel to JSON: $this");

    try {
      final jsonData = _$OrderApiModelToJson(this);
      print("Successfully converted OrderApiModel to JSON: $jsonData");
      return jsonData;
    } catch (e) {
      print("Error converting OrderApiModel to JSON: $e");
      rethrow;
    }
  }

  OrderEntity toEntity() {
    print("Converting OrderApiModel to OrderEntity...");

    try {
      final orderEntity = OrderEntity(
        orderId: id ?? '', // Handle null value
        userId: userId,
        email: email ?? '', // Handle null value
        items: productIds
            .map((product) {
              print("Mapping product: $product");
              return OrderItemEntity.fromApi(product);
            })
            .toList(),
        totalAmount: totalPrice,
        status: 'pending',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      print("Successfully converted OrderApiModel to OrderEntity: $orderEntity");
      return orderEntity;
    } catch (e) {
      print("Error converting OrderApiModel to OrderEntity: $e");
      rethrow;
    }
  }

  static List<OrderEntity> toEntityList(List<OrderApiModel> models) {
    print("Converting list of OrderApiModels to list of OrderEntities...");

    try {
      final entities = models.map((model) => model.toEntity()).toList();
      print("Successfully converted list of OrderApiModels to list of OrderEntities.");
      return entities;
    } catch (e) {
      print("Error converting list of OrderApiModels to list of OrderEntities: $e");
      rethrow;
    }
  }
}
