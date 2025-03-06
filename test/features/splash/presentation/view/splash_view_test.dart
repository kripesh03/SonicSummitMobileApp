import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/onboarding/presentation/view/onboard_view.dart';
import 'package:sonic_summit_mobile_app/features/splash/presentation/view/splash_view.dart';
import 'package:sonic_summit_mobile_app/features/splash/presentation/view_model/splash_cubit.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:mockito/mockito.dart';

class MockLoginBloc extends Mock implements LoginBloc {}

void main() {
  group('SplashView Tests', () {
    testWidgets('should navigate to OnboardingView after delay', (WidgetTester tester) async {
      // Mock the LoginBloc
      final mockLoginBloc = MockLoginBloc();

      // Build the widget tree with the mocked dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<SplashCubit>(
            create: (_) => SplashCubit(mockLoginBloc),
            child: const SplashView(),
          ),
        ),
      );

      // Initial splash screen content should be displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Let the splash screen wait for 2 seconds (duration in the SplashCubit)
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // After 2 seconds, the splash screen should navigate to OnboardingView
      expect(find.byType(OnboardingView), findsOneWidget);
    });


  });
}
