import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900]!,
  ),
  textTheme: const TextTheme().copyWith(
    bodySmall: const TextStyle(color: Colors.white),
    bodyMedium: const TextStyle(color: Colors.white),
    bodyLarge: const TextStyle(color: Colors.white),
    labelSmall: const TextStyle(color: Colors.white),
    labelMedium: const TextStyle(color: Colors.white),
    labelLarge: const TextStyle(color: Colors.white),
    displaySmall: const TextStyle(color: Colors.white),
    displayMedium: const TextStyle(color: Color(0xffAA975A)),
    displayLarge: const TextStyle(color: Colors.white),
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.grey[900]!,
    primary: Colors.grey[800]!,
    secondary: Colors.grey[700]!,
  ),
);
