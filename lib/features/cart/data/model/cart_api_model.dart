import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_item_entity.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';

part 'cart_api_model.g.dart';

@JsonSerializable()
@JsonSerializable()
class CartApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final ProductApiModel product;

  const CartApiModel({
    this.id,
    required this.product,
  });

  // From JSON
  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    return CartApiModel(
      id: json['_id'],
      product: ProductApiModel.fromJson(json['productId']),  // Corrected field name
    );
  }

  // To JSON
  Map<String, dynamic> toJson() => _$CartApiModelToJson(this);

  // Convert API Object to Entity
  CartEntity toEntity() => CartEntity(
        id: id,
        items: [
          // Map the product to a CartItemEntity, assuming quantity is 1 for now
          CartItemEntity(title: product.title ?? '', newPrice: product.newPrice)
        ],
      );

  // Convert API List to Entity List
  static List<CartEntity> toEntityList(List<CartApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [id, product];
}
