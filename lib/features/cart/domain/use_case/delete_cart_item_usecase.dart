import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/repository/cart_repository.dart';

class DeleteCartItemUseCase {
  final ICartRepository cartRepository;

  DeleteCartItemUseCase({required this.cartRepository});

  Future<Either<Failure, void>> call(String productId) async {
    return await cartRepository.deleteCartItem(productId);
  }
}
