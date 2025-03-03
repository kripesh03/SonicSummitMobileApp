import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/repository/cart_repository.dart';

class GetCartUseCase {
  final ICartRepository cartRepository;

  GetCartUseCase({required this.cartRepository});

  Future<Either<Failure, List<CartEntity>>> call() async {
    return await cartRepository.getCart();  // Now returns a list of CartEntity
  }
}

