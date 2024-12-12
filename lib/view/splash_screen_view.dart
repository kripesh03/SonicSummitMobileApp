import 'package:flutter/material.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Soft white background
      body: Center(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 253, 253, 253), // Soft pink
                Color.fromARGB(255, 218, 182, 232), // Purple
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            // Rounded corners for a modern look
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo with smooth scaling effect
              AnimatedContainer(
                duration: Duration(seconds: 3),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(1.1),
                child: Container(
                  decoration: BoxDecoration(),
                  child: Image.asset(
                    "assets/icons/logo_without_background.png",
                    width: 180, // Increased logo size for better visibility
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
