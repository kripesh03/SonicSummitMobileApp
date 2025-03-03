import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';

abstract class ICartRepository {
  Future<Either<Failure, List<CartEntity>>> getCart();  // Expecting a list of CartEntity
}
