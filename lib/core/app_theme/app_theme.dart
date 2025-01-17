import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
      fontFamily: "Roboto Regular",
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontFamily: 'Roboto Bold'),
              backgroundColor: Colors.purple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)))),
      inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(15),
          border: OutlineInputBorder(),
          labelStyle: TextStyle(
            fontSize: 20,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(),
          )),
      appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.purple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )));
}