// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartApiModel _$CartApiModelFromJson(Map<String, dynamic> json) {
  return CartApiModel(
    id: json['_id'] as String?,
    product: ProductApiModel.fromJson(json['productId'] as Map<String, dynamic>),
    itemId: json['productId']?['_id'] ?? '',  // This line will depend on your API structure
    totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,  // Added totalPrice handling
  );
}

Map<String, dynamic> _$CartApiModelToJson(CartApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'productId': instance.product.toJson(),
      'itemId': instance.itemId,  // Ensure itemId is serialized
      'totalPrice': instance.totalPrice,  // Serialize totalPrice
    };
