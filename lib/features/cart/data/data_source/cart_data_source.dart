import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';

abstract interface class ICartDataSource {
  Future<List<CartEntity>> getCart();

  Future<void> deleteCartItem(String userId, String productId);
}
