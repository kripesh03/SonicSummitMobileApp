import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/repository/order_repository.dart';

class CreateOrderUseCase {
  final IOrderRepository orderRepository;

  CreateOrderUseCase({required this.orderRepository});

  Future<Either<Failure, OrderEntity>> call(Map<String, dynamic> orderData) async {
    return await orderRepository.createOrder(orderData);
  }
}
