// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartApiModel _$CartApiModelFromJson(Map<String, dynamic> json) {
  return CartApiModel(
    id: json['_id'] as String?,
    product: ProductApiModel.fromJson(json['product'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CartApiModelToJson(CartApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'product': instance.product.toJson(),
    };
