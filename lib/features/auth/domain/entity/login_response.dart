import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String token;
  final String userId;

  const LoginResponse({
    required this.token,
    required this.userId,
  });

  @override
  List<Object> get props => [token, userId];
}
