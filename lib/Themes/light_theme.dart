import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.grey,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
    ),
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      background: Colors.grey[300]!,
      primary: Colors.grey[200]!,
      secondary: Colors.grey[300]!,
    ));
