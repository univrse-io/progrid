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
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Single Icon Page'),
      ),
      body: const Center(
        child: Icon(
          Icons.home,
          size: 100.0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
