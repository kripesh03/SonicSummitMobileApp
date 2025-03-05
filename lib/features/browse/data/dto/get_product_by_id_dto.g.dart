// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_by_id_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetProductByIdDTO _$GetProductByIdDTOFromJson(Map<String, dynamic> json) {
  return GetProductByIdDTO(
    data: ProductApiModel.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetProductByIdDTOToJson(GetProductByIdDTO instance) =>
    <String, dynamic>{
      'data': instance.data.toJson(),
    };
