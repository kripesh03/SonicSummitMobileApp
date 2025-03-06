import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/repository/order_repository.dart';

class GetOrdersByUserIdUseCase {
  final IOrderRepository orderRepository;

  GetOrdersByUserIdUseCase({required this.orderRepository});

  Future<Either<Failure, List<OrderEntity>>> call(String userId) async {
    return await orderRepository.getOrderByUserId(userId);
  }
}
