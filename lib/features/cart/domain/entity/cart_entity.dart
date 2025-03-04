import 'package:equatable/equatable.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_item_entity.dart';

class CartEntity extends Equatable {
  final String? id;
  final List<CartItemEntity> items;
  double totalPrice;  // Added totalPrice field

  CartEntity({
    this.id,
    required this.items,
    this.totalPrice = 0,  // Include totalPrice as a required parameter
  });

  @override
  List<Object?> get props => [id, items, totalPrice];  // Add totalPrice to the Equatable props
}
