import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sonic_summit_mobile_app/features/browse/data/model/product_api_model.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_item_entity.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';

part 'cart_api_model.g.dart';

@JsonSerializable()
class CartApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final ProductApiModel product;
  @JsonKey(name: 'itemId')  // Add itemId to match the API field name
  final String itemId;  // Added itemId field

  const CartApiModel({
    this.id,
    required this.product,
    required this.itemId,  // Include itemId as a required parameter
  });

  // From JSON
  factory CartApiModel.fromJson(Map<String, dynamic> json) {
  return CartApiModel(
    id: json['_id'],
    product: ProductApiModel.fromJson(json['productId']),
    itemId: json['productId']?['_id'],  // Keep itemId nullable
  );
}


  // To JSON
  Map<String, dynamic> toJson() => _$CartApiModelToJson(this);

  // Convert API Object to Entity
  CartEntity toEntity() => CartEntity(
        id: id,
        items: [
          // Map the product to a CartItemEntity, now passing itemId as well
          CartItemEntity(
            title: product.title ?? '',
            newPrice: product.newPrice,
            itemId: itemId,  // Pass itemId to CartItemEntity
          )
        ],
      );

  // Convert API List to Entity List
  static List<CartEntity> toEntityList(List<CartApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [id, product, itemId];  // Add itemId to the Equatable props
}
