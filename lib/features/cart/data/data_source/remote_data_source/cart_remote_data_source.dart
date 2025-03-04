import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/dto/get_cart_dto.dart';
import 'package:sonic_summit_mobile_app/features/cart/data/model/cart_api_model.dart';
import 'package:sonic_summit_mobile_app/features/cart/domain/entity/cart_entity.dart';

class CartRemoteDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  CartRemoteDataSource({
    required Dio dio,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _dio = dio,
        _tokenSharedPrefs = tokenSharedPrefs;

  Future<List<CartEntity>> getCart() async {
  try {
    final userIdResult = await _tokenSharedPrefs.getUserId();
    final userId = userIdResult.fold(
      (failure) {
        throw Exception('Failed to retrieve userId from SharedPreferences: ${failure.message}');
      },
      (userId) => userId,
    );

    if (userId.isEmpty) {
      throw Exception('User ID is empty');
    }

    final response = await _dio.get(ApiEndpoints.getCart(userId));

    if (response.statusCode == 200) {
      if (response.data != null && response.data is Map<String, dynamic>) {
        Map<String, dynamic> responseData = response.data;
        var items = responseData['items'] as List<dynamic>?;

        if (items != null) {
          Map<String, dynamic> dtoMap = {'items': items};
          GetCartDTO cartDTO = GetCartDTO.fromJson(dtoMap);

          // Map the items to CartEntity
          List<CartEntity> cartEntities = CartApiModel.toEntityList(cartDTO.data);

          // Extract totalPrice from responseData and ensure it's a valid double
          var totalPrice = responseData['totalPrice'];
          double totalPriceValue = 0.0;

          // Handle $numberDecimal correctly, default to 0.0 if parsing fails
          if (totalPrice is Map<String, dynamic> && totalPrice.containsKey('\$numberDecimal')) {
            totalPriceValue = double.tryParse(totalPrice['\$numberDecimal'].toString()) ?? 0.0;
          }

          // Set totalPrice in each CartEntity
          for (var cartEntity in cartEntities) {
            cartEntity.totalPrice = totalPriceValue;
          }

          return cartEntities;
        } else {
          throw Exception('Items list is null in response data');
        }
      } else {
        throw Exception('Response data is not of type Map<String, dynamic>');
      }
    } else {
      throw Exception('Failed to fetch cart. Status code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Dio error: $e');
  } catch (e) {
    throw Exception('Unknown error: $e');
  }
}


  Future<void> addToCart(String userId, String productId) async {
  try {
    final response = await _dio.post(
      "${ApiEndpoints.baseUrl}cart/add",
      data: {
        "userId": userId,
        "productId": productId,
      },
    );

    if (response.statusCode == 200) {
      debugPrint('Product added to cart successfully.');
    } else {
      throw Exception('Failed to add product to cart: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Dio error: $e');
  } catch (e) {
    throw Exception('Unknown error: $e');
  }
}

Future<void> removeItemFromCart(String userId, String productId) async {
    try {
      final response = await _dio.post(
        "${ApiEndpoints.baseUrl}cart/remove",
        data: {
          "userId": userId,
          "productId": productId,
        },
      );

      if (response.statusCode == 200) {
        debugPrint('Product removed from cart successfully.');
      } else {
        throw Exception('Failed to remove product from cart: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Dio error: $e');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }


}
