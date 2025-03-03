import 'dart:convert';

import 'package:dio/dio.dart';
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
    var response = await _dio.get(ApiEndpoints.getCart("67c419ff20ecd69cd9fc327c"));

    // Debug: Print full response data for inspection
    print('Full response data: ${jsonEncode(response.data)}');

    if (response.statusCode == 200) {
      // Check if response.data is not null and is a Map
      if (response.data != null) {
        if (response.data is Map<String, dynamic>) {
          Map<String, dynamic> responseData = response.data;

          // Extract the 'items' list from responseData
          var items = responseData['items'] as List<dynamic>?;
          print('Items list: $items');  // Print the 'items' list for inspection

          if (items != null) {
            // Debug: Check the structure of the items
            print('Items structure: ${jsonEncode(items)}');

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


}
