import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';

part 'get_product_by_id_dto.g.dart';

@JsonSerializable()
class GetProductByIdDTO {
  final ProductApiModel data;

  GetProductByIdDTO({
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetProductByIdDTOToJson(this);

  factory GetProductByIdDTO.fromJson(Map<String, dynamic> json) {
    return GetProductByIdDTO(
      data: ProductApiModel.fromJson(json['data']),
    );
  }
}
