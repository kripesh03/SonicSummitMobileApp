import 'package:flutter/material.dart';
import 'package:sonic_summit_mobile_app/core/app_theme/app_theme.dart';
import 'package:sonic_summit_mobile_app/view/onboard_view.dart';

class MyApp extends StatelessWidget {
  final bool isDark;
  const MyApp({super.key, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: getApplicationTheme(),
      routes: {
        "/": (context) => const OnboardingView(),
      },
    );
  }
}
