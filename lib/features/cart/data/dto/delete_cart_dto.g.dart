// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteCartDTO _$DeleteCartDTOFromJson(Map<String, dynamic> json) {
  return DeleteCartDTO(
    userId: json['userId'] as String,
    productId: json['productId'] as String,
  );
}

Map<String, dynamic> _$DeleteCartDTOToJson(DeleteCartDTO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'productId': instance.productId,
    };
