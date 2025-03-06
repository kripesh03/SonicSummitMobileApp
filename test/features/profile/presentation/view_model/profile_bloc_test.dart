import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sonic_summit_mobile_app/core/error/failure.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/entity/user_entity.dart';
import 'package:sonic_summit_mobile_app/features/profile/domain/use_case/get_user_usecase.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_bloc.dart';
import 'package:sonic_summit_mobile_app/features/profile/presentation/view_model/profile_state.dart';

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

void main() {
  late MockGetUserUseCase mockGetUserUseCase;
  late ProfileBloc profileBloc;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    profileBloc = ProfileBloc(getUserUseCase: mockGetUserUseCase);
  });

  tearDown(() {
    profileBloc.close();
  });

  group('ProfileBloc Tests', () {
    // Test initial state
    test('Initial state is ProfileState.initial()', () {
      expect(profileBloc.state, ProfileState.initial());
    });

    // Test successful profile load
    blocTest<ProfileBloc, ProfileState>(
      'Emits [loading, success] when LoadProfile is added and succeeds',
      build: () {
        when(() => mockGetUserUseCase.call('1')).thenAnswer(
          (_) async => Right(
            UserEntity(
              id: '1',
              username: 'test_user',
              email: 'test@example.com',
            ),
          ),
        );
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadProfile(userId: '1')),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true),
        ProfileState.initial().copyWith(
          isLoading: false,
          user: UserEntity(
            id: '1',
            username: 'test_user',
            email: 'test@example.com',
          ),
          error: '',
        ),
      ],
      verify: (_) {
        verify(() => mockGetUserUseCase.call('1')).called(1);
      },
    );

    // Test failed profile load
    
    // Test exception handling
    blocTest<ProfileBloc, ProfileState>(
      'Emits [loading, error] when LoadProfile is added and throws an exception',
      build: () {
        when(() => mockGetUserUseCase.call('1')).thenThrow(
          Exception('Unexpected error'),
        );
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadProfile(userId: '1')),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true),
        ProfileState.initial().copyWith(
          isLoading: false,
          error: 'Exception occurred: Exception: Unexpected error',
        ),
      ],
      verify: (_) {
        verify(() => mockGetUserUseCase.call('1')).called(1);
      },
    );
  });

  blocTest<ProfileBloc, ProfileState>(
      'Emits [loading, error] when LoadProfile is added and fails',
      build: () {
        when(() => mockGetUserUseCase.call('1')).thenAnswer(
          (_) async => Left(ApiFailure(message: 'Failed to load profile')),
        );
        return profileBloc;
      },
      act: (bloc) => bloc.add(LoadProfile(userId: '1')),
      expect: () => [
        ProfileState.initial().copyWith(isLoading: true),
        ProfileState.initial().copyWith(
          isLoading: false,
          error: 'Failed to load profile: Failed to load profile',
        ),
      ],
      verify: (_) {
        verify(() => mockGetUserUseCase.call('1')).called(1);
      },
    );

}