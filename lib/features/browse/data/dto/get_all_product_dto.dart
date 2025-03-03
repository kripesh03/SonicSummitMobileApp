import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';

part 'get_all_product_dto.g.dart';

@JsonSerializable()
class GetAllProductDTO {
  final List<ProductApiModel> data;

  GetAllProductDTO({
    required this.data,
  });

  Map<String, dynamic> toJson() => _$GetAllProductDTOToJson(this);

  factory GetAllProductDTO.fromJson(List<dynamic> json) {
    return GetAllProductDTO(
      data: json.map((product) => ProductApiModel.fromJson(product)).toList(),
    );
  }
}