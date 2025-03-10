import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view/login_view.dart';
import 'package:sonic_summit_mobile_app/features/auth/presentation/view_model/login/login_bloc.dart';

class OnboardingCubit extends Cubit<void> {
  OnboardingCubit(this._loginBloc) : super(null);

  final LoginBloc _loginBloc;

  Future<void> navigateToLogin(BuildContext context) async {
    // Add delay if necessary to show the onboarding screen
    await Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: _loginBloc,
              child: LoginView(),
            ),
          ),
        );
      }
    });
  }
}
