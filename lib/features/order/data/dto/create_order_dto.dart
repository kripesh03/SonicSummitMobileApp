import 'package:json_annotation/json_annotation.dart';

part 'create_order_dto.g.dart';

@JsonSerializable()
class CreateOrderDTO {
  final String userId;
  final String name;
  final String phone;

  CreateOrderDTO({
    required this.userId,
    required this.name,
    required this.phone,
  });

  factory CreateOrderDTO.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderDTOToJson(this);
}
