import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sonic_summit_mobile_app/core/common/snackbar/snackbar.dart';
import 'package:sonic_summit_mobile_app/features/auth/domain/use_case/register_user_usecase.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc({
    required RegisterUseCase registerUseCase,
  })  :
        _registerUseCase = registerUseCase,
        super(RegisterState.initial()) {
    on<LoadCoursesAndBatches>(_onLoadCoursesAndBatches);
    on<RegisterStudent>(_onRegisterEvent);

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
      role: event.role,
      password: event.password,
    ));

    result.fold(
      (l) => emit(state.copyWith(isLoading: false, isSuccess: false)),
      (r) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
            context: event.context, message: "Registration Successful");
      },
    );
  }
}
