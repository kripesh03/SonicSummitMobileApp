import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? profilePicture;
  final String? bio; // Added bio field

  UserEntity({
    required this.id,
    required this.username,
    required this.email,
    this.profilePicture,
    this.bio,
  });

  @override
  List<Object?> get props => [id, username, email, profilePicture, bio];
}
