import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs(this._sharedPreferences);

  // Save token and userId
  Future<Either<Failure, void>> saveAuthData(String token, String userId) async {
    try {
      await _sharedPreferences.setString('token', token);
      await _sharedPreferences.setString('userId', userId);
      return Right(null); // Successfully saved
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString())); // Handling errors
    }
  }

  // Get token
  Future<Either<Failure, String>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      return Right(token ?? '');
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Get userId
  Future<Either<Failure, String>> getUserId() async {
    try {
      final userId = _sharedPreferences.getString('userId');
      return Right(userId ?? '');
    } catch (e) {
      return Left(SharedPrefsFailure(message: e.toString()));
    }
  }

  // Clear auth data (if needed for logout)
  Future<void> clearAuthData() async {
    await _sharedPreferences.remove('token');
    await _sharedPreferences.remove('userId');
  }
}
