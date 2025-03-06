import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';

abstract class IOrderRepository {
  Future<Either<Failure, OrderEntity>> createOrder(Map<String, dynamic> orderData);
  
  Future<Either<Failure, List<OrderEntity>>> getOrderByUserId(String userId);
}
