import 'package:flutter/material.dart';
import 'package:task_tacker/constans/colors.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey,
  ),
  textTheme: const TextTheme().copyWith(
    bodySmall: const TextStyle(color: Colors.black),
    bodyMedium: const TextStyle(color: Colors.black),
    bodyLarge: const TextStyle(color: Colors.black),
    labelSmall: const TextStyle(color: Colors.black),
    labelMedium: const TextStyle(color: Colors.black),
    labelLarge: const TextStyle(color: Colors.black),
    displaySmall: const TextStyle(color: Colors.black),
    displayMedium: const TextStyle(color: Colors.black),
    displayLarge: const TextStyle(color: Colors.black),
  ),
  colorScheme: ColorScheme.light(
    background: kBgColor,
    primary: Colors.white,
    secondary: Colors.grey,
  ),
);
