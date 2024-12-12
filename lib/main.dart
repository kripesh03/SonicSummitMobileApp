import 'package:flutter/material.dart';
import 'package:sonic_summit_mobile_app/view/login_view.dart';
import 'package:sonic_summit_mobile_app/view/registration_view.dart';
import 'package:sonic_summit_mobile_app/view/splash_screen_view.dart';

// import 'package:first_flutter_apps/app.dart';
void main() {
  runApp(
    MaterialApp(
      initialRoute: '//',
      routes: {
        '//': (context) => SplashScreenView(),
      },
    ),
  );
}
