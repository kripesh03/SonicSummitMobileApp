// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderApiModel _$OrderApiModelFromJson(Map<String, dynamic> json) {
  return OrderApiModel(
    id: json['_id'] as String?,
    userId: json['userId'] as String,
    name: json['name'] as String?,
    email: json['email'] as String?,
    phone: (json['phone'] ?? '').toString(), // Ensure phone is always a String
    productIds: json['productIds'] as List<dynamic>,
    totalPrice: (json['totalPrice'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}


Map<String, dynamic> _$OrderApiModelToJson(OrderApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'productIds': instance.productIds,
      'totalPrice': instance.totalPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
