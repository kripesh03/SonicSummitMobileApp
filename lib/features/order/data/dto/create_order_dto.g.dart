// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderDTO _$CreateOrderDTOFromJson(Map<String, dynamic> json) {
  return CreateOrderDTO(
    userId: json['userId'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$CreateOrderDTOToJson(CreateOrderDTO instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'phone': instance.phone,
    };
