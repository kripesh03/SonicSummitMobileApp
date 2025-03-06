import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view/login_view.dart';
import 'package:sonic_summit_mobile_app/features/onboarding/presentation/view/onboard_view.dart';
import 'package:sonic_summit_mobile_app/features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:mockito/mockito.dart';

class MockLoginBloc extends Mock implements LoginBloc {}
class MockOnboardingCubit extends Mock implements OnboardingCubit {}

void main() {
  group('OnboardingView Tests', () {
    testWidgets('should display onboarding content correctly', (WidgetTester tester) async {
      // Mock the LoginBloc and OnboardingCubit
      final mockLoginBloc = MockLoginBloc();
      final mockOnboardingCubit = MockOnboardingCubit();

      // Build the widget tree with the mocked dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<OnboardingCubit>(
            create: (_) => mockOnboardingCubit,
            child: OnboardingView(),
          ),
        ),
      );

      // Check if the first image, title, and description are displayed
      expect(find.text('Explore Music Globally'), findsOneWidget);
      expect(find.text('Discover music from artists around the world at your fingertips.'), findsOneWidget);
      expect(find.byType(Image), findsNWidgets(1)); // Image of first page

      // Check if the dot indicator for the first page is present
      expect(find.byType(AnimatedContainer), findsNWidgets(3));
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    
    testWidgets('should update dot indicators on page change', (WidgetTester tester) async {
      // Mock the LoginBloc and OnboardingCubit
      final mockLoginBloc = MockLoginBloc();
      final mockOnboardingCubit = MockOnboardingCubit();

      // Build the widget tree with the mocked dependencies
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<OnboardingCubit>(
            create: (_) => mockOnboardingCubit,
            child: OnboardingView(),
          ),
        ),
      );

      // Swipe to the next page
      await tester.drag(find.byType(PageView), const Offset(-300.0, 0.0));
      await tester.pumpAndSettle();

      // Verify the second dot is selected
      expect(find.byType(AnimatedContainer).at(1), findsOneWidget);
    });
  });
}
