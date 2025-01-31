import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sonic_summit_mobile_app/core/common/snackbar/snackbar.dart';

import 'package:sonic_summit_mobile_app/features/auth/domain/use_case/register_user_usecase.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/use_case/upload_iamge_usecase.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  
  final RegisterUseCase _registerUseCase;
  final UploadImageUsecase _uploadImageUsecase;

  RegisterBloc({

    required RegisterUseCase registerUseCase,
    required UploadImageUsecase uploadImageUsecase,
  })  : 
        _registerUseCase = registerUseCase,
        _uploadImageUsecase = uploadImageUsecase,
        super(RegisterState.initial()) {
    on<LoadCoursesAndBatches>(_onLoadCoursesAndBatches);
    on<RegisterStudent>(_onRegisterEvent);
    on<UploadImage>(_onLoadImage);

    add(LoadCoursesAndBatches());
  }

  void _onLoadCoursesAndBatches(
    LoadCoursesAndBatches event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(isLoading: false, isSuccess: true));
  }

  void _onRegisterEvent(
    RegisterStudent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _registerUseCase.call(RegisterUserParams(

      username: event.username,
      email: event.email,
      bio: event.bio,
      password: event.password,
      profilePicture: state.imageName,
    ));

    result.fold(
      (l) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
        showMySnackBar(
            context: event.context, message: l.message, color: Colors.red);
      },
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
      },
    );
  }

  void _onLoadImage(
    UploadImage event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _uploadImageUsecase.call(
      UploadImageParams(
        file: event.file,
      ),
    );

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true, imageName: r));
      },
    );
  }
}
