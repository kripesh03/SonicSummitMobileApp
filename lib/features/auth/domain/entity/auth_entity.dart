import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? userId;
  final String username;
  final String email;
  final String? profilePicture;
  final String bio;
  final String role;
  final String password;

  const AuthEntity({
    this.userId,
    required this.username,
    required this.email,
    this.profilePicture,
    required this.bio,
    required this.role,
    required this.password,
  });

  @override
  List<Object?> get props =>
      [userId, username, email, profilePicture, bio, role, password];
}
