import 'package:dio/dio.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/features/order/data/model/order_api_model.dart';
import 'package:sonic_summit_mobile_app/features/order/domain/entity/order_entity.dart';

class OrderRemoteDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  OrderRemoteDataSource({
    required Dio dio,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _dio = dio,
        _tokenSharedPrefs = tokenSharedPrefs;

  Future<OrderEntity> createOrder(String name, String phone) async {
    try {
      final userIdResult = await _tokenSharedPrefs.getUserId();
      final userId = userIdResult.fold(
        (failure) => throw Exception('Failed to retrieve userId: ${failure.message}'),
        (userId) => userId,
      );

      final response = await _dio.post(
        ApiEndpoints.createOrder,
        data: {"userId": userId, "name": name, "phone": phone},
      );

      if (response.statusCode == 200) {
        return OrderApiModel.fromJson(response.data).toEntity();
      } else {
        throw Exception('Failed to create order: ${response.statusCode}, ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}, StatusCode: ${e.response?.statusCode}, Data: ${e.response?.data}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<List<OrderEntity>> getOrdersByUserId(String userId) async {
    try {
      final response = await _dio.get(ApiEndpoints.getOrdersByUserId(userId));

      if (response.statusCode == 200) {
        List<dynamic> ordersJson = response.data;
        return ordersJson.map((order) => OrderApiModel.fromJson(order).toEntity()).toList();
      } else {
        throw Exception('Failed to fetch orders: ${response.statusCode}, ${response.data}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}, StatusCode: ${e.response?.statusCode}, Data: ${e.response?.data}');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }
}
