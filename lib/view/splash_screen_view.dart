import 'package:flutter/material.dart';
import 'package:sonic_summit_mobile_app/view/onboard_view.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to onboarding screen after a delay
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const OnboardingView()), // Navigate to Onboarding
      );
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 253, 253, 253), // Soft pink
                Color.fromARGB(255, 218, 182, 232), // Purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(seconds: 3),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(1.1),
                child: Container(
                  decoration: const BoxDecoration(),
                  child: Image.asset(
                    "assets/icons/logo_without_background.png",
                    width: 180,
                    height: 180,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
