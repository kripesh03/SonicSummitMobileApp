import 'package:equatable/equatable.dart';
import 'package:sonic_summit_mobile_app/features/profile/splash/domain/entity/user_entity.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final String error;
  final UserEntity? user;

  const ProfileState({
    required this.isLoading,
    required this.error,
    this.user,
  });

  factory ProfileState.initial() {
    return const ProfileState(isLoading: false, error: '', user: null);
  }

  ProfileState copyWith({
    bool? isLoading,
    String? error,
    UserEntity? user,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, user];
}
