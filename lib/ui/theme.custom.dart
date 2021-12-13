
import 'package:flutter/material.dart';

class CustomDarkTheme {

  final ThemeData theme = ThemeData(
    colorScheme: const ColorScheme(
      background: background,
      brightness: Brightness.dark,
      secondary: accent,
      primary: background,
      error: textError,
      onBackground: background,
      onError: textError,
      onPrimary: background,
      onSecondary: accent,
      onSurface: accent,
      primaryVariant: deepBackground,
      secondaryVariant: deepBackground,
      surface: deepBackground
    ),
    textTheme: const TextTheme(
      headline4: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold
      ),
      headline2: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold
      )
    ),
    appBarTheme: const AppBarTheme(
      foregroundColor: textAccent
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: accent,
    )
  );


  static const Color deepBackground = Color(0xff0D0D0D);
  static const Color background = Color(0xff404040);
  static const Color text = Colors.white;
  static const Color textAccent = Color(0xffF24405);
  static const Color textError = Color(0xffA62F03);
  static const Color accent = Color(0xffA62F03);
}