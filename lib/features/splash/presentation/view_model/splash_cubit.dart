import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view/login_view.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view_model/login/login_bloc.dart';
import 'package:sonic_summit_mobile_app/features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'package:sonic_summit_mobile_app/features/onboarding/presentation/view/onboard_view.dart';

class SplashCubit extends Cubit<void> {
  SplashCubit(this._loginBloc) : super(null);

  final LoginBloc _loginBloc;

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      // Navigate to the onboarding screen first
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => OnboardingCubit(_loginBloc),
              child: const OnboardingView(),
            ),
          ),
        );
      }
    });
  }
}
