import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/data_source/remote_data_source/cart_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/repository/cart_repository.dart';

class CartRemoteRepository implements ICartRepository {
  final CartRemoteDataSource remoteDataSource;
  final TokenSharedPrefs tokenSharedPrefs;

  CartRemoteRepository({
    required this.remoteDataSource,
    required this.tokenSharedPrefs,
  });

  @override
  Future<Either<Failure, List<CartEntity>>> getCart() async {
    try {
      final cartItems = await remoteDataSource.getCart();
      return Right(cartItems);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToCart(String productId) async {
    try {
      final userIdResult = await tokenSharedPrefs.getUserId();
      
      return userIdResult.fold(
        (failure) => Left(failure), // If failed to get userId, return failure
        (userId) async {
          await remoteDataSource.addToCart(userId, productId);
          return Right(null);
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCartItem(String productId) async {
    try {
      final userIdResult = await tokenSharedPrefs.getUserId();
      
      return userIdResult.fold(
        (failure) => Left(failure), // If failed to get userId, return failure
        (userId) async {
          await remoteDataSource.removeItemFromCart(userId, productId);
          return Right(null);
        },
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
