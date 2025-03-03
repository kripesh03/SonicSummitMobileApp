// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_cart_dto.dart';

// ************************************************************************** 
// JsonSerializableGenerator
// **************************************************************************

GetCartDTO _$GetCartDTOFromJson(List<dynamic> json) =>
    GetCartDTO(
      data: json.map((cartItem) => CartApiModel.fromJson(cartItem)).toList(),
    );

Map<String, dynamic> _$GetCartDTOToJson(GetCartDTO instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
