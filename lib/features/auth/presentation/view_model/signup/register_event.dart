part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class LoadCoursesAndBatches extends RegisterEvent {}

class UploadImage extends RegisterEvent {
  final File file;

  const UploadImage({
    required this.file,
  });
}

class RegisterStudent extends RegisterEvent {
  final BuildContext context;
  final String username;
  final String email;
  final String bio;
  final String password;
  final String? profilePicture;


  const RegisterStudent({
    required this.context,
    required this.username,
    required this.email,
    required this.bio,
    required this.password,
    this.profilePicture,

  });
}
