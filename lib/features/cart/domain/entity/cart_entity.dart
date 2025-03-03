import 'package:equatable/equatable.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_item_entity.dart';

class CartEntity extends Equatable {
  final String? id;
  final List<CartItemEntity> items;

  CartEntity({
    this.id,
    required this.items,
  });

  @override
  List<Object?> get props => [id, items];
}
