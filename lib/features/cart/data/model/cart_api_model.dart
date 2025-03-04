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
  @JsonKey(name: 'itemId')
  final String itemId;
  @JsonKey(name: 'totalPrice')  // Added totalPrice field
  final double totalPrice;  // Added totalPrice field

  const CartApiModel({
    this.id,
    required this.product,
    required this.itemId,
    required this.totalPrice,  // Include totalPrice as a required parameter
  });

  // From JSON
  factory CartApiModel.fromJson(Map<String, dynamic> json) {
    return CartApiModel(
      id: json['_id'],
      product: ProductApiModel.fromJson(json['productId']),
      itemId: json['productId']?['_id'],  // Keep itemId nullable
      totalPrice: json['totalPrice']?.toDouble() ?? 0.0,  // Add totalPrice conversion
    );
  }

  // To JSON
  Map<String, dynamic> toJson() => _$CartApiModelToJson(this);

  // Convert API Object to Entity
  CartEntity toEntity() => CartEntity(
        id: id,
        items: [
          CartItemEntity(
            title: product.title ?? '',
            newPrice: product.newPrice,
            itemId: itemId,
          )
        ], totalPrice: totalPrice,
      );

  // Convert API List to Entity List
  static List<CartEntity> toEntityList(List<CartApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [id, product, itemId, totalPrice];  // Add totalPrice to the Equatable props
}
