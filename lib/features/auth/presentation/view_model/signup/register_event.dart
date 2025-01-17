part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class LoadCoursesAndBatches extends RegisterEvent {}

class RegisterStudent extends RegisterEvent {
  final BuildContext context;
  final String username;
  final String email;
  final String bio;
  final String role;
  final String password;

  const RegisterStudent({
    required this.context,
    required this.username,
    required this.email,
    required this.bio,
    required this.role,
    required this.password,
  });
}
