import 'package:flutter/material.dart';
import 'package:progrid/pages/login_page.dart';
import 'package:progrid/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // initially show login page
  bool showLoginPage = true;

  // toggle between login and register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTapSwitchPage: togglePages,
      );
    } else {
      return RegisterPage(
        onTapSwitchPage: togglePages,
      );
    }
  }
}