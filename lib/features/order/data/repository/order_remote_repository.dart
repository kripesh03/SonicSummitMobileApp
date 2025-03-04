import 'package:dartz/dartz.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';
import 'package:sonic_summit_mobile_app/features/order/data/data_source/remote_data_source/order_remote_data_source.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/repository/order_repository.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';

class OrderRemoteRepository implements IOrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final TokenSharedPrefs tokenSharedPrefs;

  OrderRemoteRepository({
    required this.remoteDataSource,
    required this.tokenSharedPrefs,
  });

@override
Future<Either<Failure, OrderEntity>> createOrder(Map<String, dynamic> orderData) async {
  try {
    final userIdResult = await tokenSharedPrefs.getUserId();

    return userIdResult.fold(
      (failure) => Left(failure),
      (userId) async {
        orderData['userId'] = userId;

        // Only send name, phone, and userId to the remote data source
        final orderResponse = await remoteDataSource.createOrder(
          orderData['name'],
          orderData['phone'] // Exclude email as it's not present in orderData
        );
        return Right(orderResponse);
      },
    );
  } catch (e) {
    return Left(ApiFailure(message: e.toString()));
  }
}
}
