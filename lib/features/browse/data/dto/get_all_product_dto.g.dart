// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_product_dto.dart';

// ************************************************************************** 
// JsonSerializableGenerator
// **************************************************************************

GetAllProductDTO _$GetAllProductDTOFromJson(List<dynamic> json) =>
    GetAllProductDTO(
      data: json.map((product) => ProductApiModel.fromJson(product)).toList(),
    );

Map<String, dynamic> _$GetAllProductDTOToJson(GetAllProductDTO instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
    };
