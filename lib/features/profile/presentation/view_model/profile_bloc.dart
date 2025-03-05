import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/use_case/get_user_usecase.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_state.dart';

part 'profile_event.dart'; // Ensure you have the event definition

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetUserUseCase getUserUseCase; // Declare the use case

  // Inject the use case via constructor
  ProfileBloc({required this.getUserUseCase}) : super(ProfileState.initial()) {
    on<LoadProfile>(_onLoadProfile); // Register event handler
  }

  // Handle the LoadProfile event
  Future<void> _onLoadProfile(
      LoadProfile event, Emitter<ProfileState> emit) async {
    try {
      debugPrint(
          'Loading profile for userId: ${event.userId}'); // Debugging line
      emit(state.copyWith(isLoading: true));

      final result =
          await getUserUseCase.call(event.userId); // Correct method call

      result.fold(
        (failure) {
          debugPrint(
              'Profile load failed: ${failure.message}'); // Debugging line
          emit(state.copyWith(
              isLoading: false,
              error: 'Failed to load profile: ${failure.message}'));
        },
        (user) {
          debugPrint(
              'User fetched successfully: ${user.username}'); // Debugging line
          emit(state.copyWith(isLoading: false, user: user, error: ''));
        },
      );
    } catch (e) {
      debugPrint('Exception occurred: $e'); // Debugging line
      emit(state.copyWith(isLoading: false, error: 'Exception occurred: $e'));
    }
  }
}
