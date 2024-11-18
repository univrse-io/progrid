import 'package:flutter/material.dart';
import 'package:progrid/themes.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: GlobalThemeData.lightThemeData,
      // home: const AuthPage(),
    );
  }
}
