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
      // Retrieve the userId from SharedPreferences
      final userIdResult = await _tokenSharedPrefs.getUserId();

      // Check if retrieving the userId was successful
      final userId = userIdResult.fold(
        (failure) {
          throw Exception('Failed to retrieve userId from SharedPreferences: ${failure.message}');
        },
        (userId) => userId,
      );

      // Check if userId is not empty
      if (userId.isEmpty) {
        throw Exception('User ID is empty');
      }

      // Use the userId in the API call
      final response = await _dio.get(ApiEndpoints.getCart(userId));

      // Debug: Print full response data for inspection
      print('Full response data: ${jsonEncode(response.data)}');

      if (response.statusCode == 200) {
        // Check if response.data is not null and is a Map
        if (response.data != null) {
          if (response.data is Map<String, dynamic>) {
            Map<String, dynamic> responseData = response.data;

            // Extract the 'items' list from responseData
            var items = responseData['items'] as List<dynamic>?;

            if (items != null) {
              // Wrap the 'items' into a map if necessary for the DTO
              Map<String, dynamic> dtoMap = {
                'items': items,  // Ensure the DTO can handle this structure
              };

              // Now pass this into the GetCartDTO.fromJson method
              GetCartDTO cartDTO = GetCartDTO.fromJson(dtoMap);

              return CartApiModel.toEntityList(cartDTO.data);
            } else {
              throw Exception('Items list is null in response data');
            }
          } else {
            throw Exception('Response data is not of type Map<String, dynamic>');
          }
        } else {
          throw Exception('Response data is null');
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
