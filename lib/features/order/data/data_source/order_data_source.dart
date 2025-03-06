import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';

abstract interface class IOrderDataSource {
  Future<List<OrderEntity>> getOrders(String userId);
  Future<OrderEntity> getOrdersByUserId(String userId);
  Future<void> createOrder(Map<String, dynamic> orderData);
}
