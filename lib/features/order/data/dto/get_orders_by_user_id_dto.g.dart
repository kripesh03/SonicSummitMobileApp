// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_orders_by_user_id_dto.dart';

// **************************************************************************  
// JsonSerializableGenerator  
// **************************************************************************

GetOrdersByUserIdDTO _$GetOrdersByUserIdDTOFromJson(Map<String, dynamic> json) {
  return GetOrdersByUserIdDTO(
    orders: (json['orders'] as List<dynamic>)
        .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$GetOrdersByUserIdDTOToJson(GetOrdersByUserIdDTO instance) =>
    <String, dynamic>{
      'orders': instance.orders.map((e) => e.toJson()).toList(),
    };
