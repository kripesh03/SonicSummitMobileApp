import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/data_source/remote_data_source/cart_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/repository/cart_repository.dart';

class CartRemoteRepository implements ICartRepository {
  final CartRemoteDataSource remoteDataSource;

  CartRemoteRepository({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CartEntity>>> getCart() async {
    try {
      final cartItems = await remoteDataSource.getCart();  // Assuming remoteDataSource returns a List<CartEntity>
      return Right(cartItems);
    } catch (e) {
      return Left(
        ApiFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
