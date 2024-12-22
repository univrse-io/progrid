import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color surface = Color(0xFFF4F4F4);
  static const Color onSurface = Color(0xFF1D1A16);
  static const Color secondary = Color(0xFF908880);
  static const Color tertiary = Color.fromARGB(255, 182, 176, 170);
  static const Color red = Color(0xFFAE4040);
  static const Color yellow = Color.fromARGB(255, 230, 200, 31);
  static const Color green = Color(0xFF7DAC6D);
  static const Color blue = Color.fromARGB(255, 53, 87, 119);
}

final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.grey[800],
    colorScheme: ColorScheme.light(
      primary: AppColors.onSurface,
      onSecondaryContainer: Colors.white,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      onSecondary: Colors.white,
      error: AppColors.red,
    ),
    fontFamily: GoogleFonts.roboto().fontFamily,
    actionIconTheme: ActionIconThemeData(
      backButtonIconBuilder: (context) => Icon(Icons.arrow_back, size: 34),
    ),
    cardTheme: CardTheme(margin: EdgeInsets.zero),
    inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14)),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            textStyle: TextStyle(fontWeight: FontWeight.w600),
            minimumSize: Size.fromHeight(45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: TextStyle(fontWeight: FontWeight.w600),
            minimumSize: Size.fromHeight(45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))));

final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[300],
    colorScheme: ColorScheme.dark(
      primary: Colors.grey[300]!,
      secondary: Colors.grey[500]!,
      surface: Colors.grey[900]!,
      error: Colors.red,
    ),
    fontFamily: GoogleFonts.roboto().fontFamily,
    inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14)),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
            textStyle: TextStyle(fontWeight: FontWeight.w600),
            minimumSize: Size.fromHeight(45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            textStyle: TextStyle(fontWeight: FontWeight.w600),
            minimumSize: Size.fromHeight(45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))));
