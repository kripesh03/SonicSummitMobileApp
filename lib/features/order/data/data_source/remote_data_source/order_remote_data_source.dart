import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/features/order/data/dto/create_order_dto.dart';
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
        (failure) {
          throw Exception('Failed to retrieve userId from SharedPreferences: ${failure.message}');
        },
        (userId) => userId,
      );

      final createOrderDTO = CreateOrderDTO(userId: userId, name: name, phone: phone);
      final requestData = createOrderDTO.toJson();

      // Debugging: Print request payload
      print("Sending Order Request: $requestData");

      final response = await _dio.post(
        ApiEndpoints.createOrder,
        data: requestData,
      );

      // Debugging: Print raw response
      print("Order API Response: ${response.data}");

      if (response.statusCode == 200) {
        final orderData = response.data;
        final orderApiModel = OrderApiModel.fromJson(orderData['order']);

        return orderApiModel.toEntity();
      } else {
        throw Exception('Failed to create order: ${response.statusCode}, ${response.data}');
      }
    } on DioException catch (e) {
      // Debugging: Print detailed Dio error info
      print("Dio Error - Type: ${e.type}, Message: ${e.message}");
      if (e.response != null) {
        print("Dio Error - Response Data: ${e.response?.data}");
        print("Dio Error - Response Status Code: ${e.response?.statusCode}");
      }
      throw Exception('Dio error: ${e.message}, StatusCode: ${e.response?.statusCode}, Data: ${e.response?.data}');
    } catch (e) {
      // Debugging: Print any unknown error
      print("Unknown error occurred: $e");
      throw Exception('Unknown error: $e');
    }
  }
}
