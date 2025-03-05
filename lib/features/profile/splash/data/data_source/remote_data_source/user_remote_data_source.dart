import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sonic_summit_mobile_app/app/constants/api_endpoints.dart';
import 'package:sonic_summit_mobile_app/app/shared_prefs/token_shared_prefs.dart';
import 'package:sonic_summit_mobile_app/features/profile/splash/data/dto/get_user_dto.dart';
import 'package:sonic_summit_mobile_app/features/profile/splash/domain/entity/user_entity.dart';

class UserRemoteDataSource {
  final Dio _dio;
  final TokenSharedPrefs _tokenSharedPrefs;

  UserRemoteDataSource({
    required Dio dio,
    required TokenSharedPrefs tokenSharedPrefs,
  })  : _dio = dio,
        _tokenSharedPrefs = tokenSharedPrefs;

  Future<UserEntity> getUser(String userId) async {
  try {
    final response = await _dio.get(ApiEndpoints.getUser(userId));

    debugPrint('API Response: ${response.data}'); // Debug API response

    if (response.statusCode == 200) {
      if (response.data != null && response.data is Map<String, dynamic>) {
        GetUserDTO userDTO = GetUserDTO.fromJson(response.data); // No "data" key
        return userDTO.user.toEntity(); // Use "user" instead of "data"
      } else {
        throw Exception('Invalid API response format.');
      }
    } else {
      throw Exception('Failed to fetch user data. Status code: ${response.statusCode}');
    }
  } on DioException catch (e) {
    throw Exception('Dio error: $e');
  } catch (e) {
    throw Exception('Unknown error: $e');
  }
}

}
