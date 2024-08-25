import 'package:flutter/material.dart';

const Color redColor = Colors.red;
const Color blackColor = Colors.black;

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: blackColor,
  scaffoldBackgroundColor: blackColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: blackColor,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: redColor,
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white70),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: blackColor,
    border: OutlineInputBorder(),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: redColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: redColor),
    ),
    labelStyle: TextStyle(color: redColor),
  ),
  iconTheme: const IconThemeData(
    color: redColor,
  ),
);
