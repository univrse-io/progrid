import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GlobalThemeData {
  // base light theme
  static ThemeData lightThemeData = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.grey[800],
    colorScheme: ColorScheme.light(
      primary: Colors.grey[800]!,
      secondary: Colors.grey[600]!,
      onSecondary: Colors.white,
      error: Colors.red,
    ),
    fontFamily: GoogleFonts.notoSans().fontFamily,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );

  // to implement: dark theme
  static ThemeData darkThemeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[300],
    colorScheme: ColorScheme.dark(
      primary: Colors.grey[300]!,
      secondary: Colors.grey[500]!,
      surface: Colors.grey[900]!,
      error: Colors.red,
    ),
    fontFamily: GoogleFonts.notoSans().fontFamily,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: const TextTheme(
      bodyMedium: TextStyle(fontSize: 14),
    ),
  );
}
