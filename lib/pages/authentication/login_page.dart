import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_auth.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final carbonToken = Theme.of(context).extension<CarbonToken>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final pageController = PageController();

  @override
  Widget build(BuildContext context) => Scaffold(
    /// TODO: Insert background image.
    appBar: AppBar(
      title: Image.asset('assets/images/progrid_black.png', height: 35),
    ),
    body: SizedBox(
      width: 480,
      child: PageView(
        controller: pageController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(kIsWeb ? 24 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacing.$7(),
                Text('Welcome back!', style: CarbonTextStyle.heading05),
                const Spacing.$2(),
                Row(
                  children: [
                    const Text('Not a member? '),
                    CarbonLink(
                      onPressed: () => pageController.jumpToPage(1),
                      label: 'Register',
                      isInline: true,
                    ),
                  ],
                ),
                const Spacing.$7(),
                const Divider(),
                const Spacing.$5(),
                // TODO: Validate email input.
                CarbonTextInput(
                  controller: emailController,
                  labelText: 'Email',
                ),
                const Spacing.$3(),
                CarbonTextInput(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                const Spacing.$3(),
                Row(
                  children: [
                    // TODO: Implement 'Remember me' functionality.
                    const Spacer(),
                    CarbonLink(
                      onPressed: () => pageController.jumpToPage(2),
                      label: 'Forgot Password?',
                    ),
                  ],
                ),
                const Spacing.$5(),
                FilledButton(
                  onPressed:
                      () => FirebaseAuthService()
                          .login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          )
                          .onError<FirebaseAuthException>((e, _) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: Text(e.message ?? e.code),
                                    ),
                              );
                            }
                            passwordController.clear();
                          }),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
          RegisterPage(pageController),
          ForgotPasswordPage(pageController),
        ],
      ),
    ),
    bottomNavigationBar: ListTile(
      tileColor: carbonToken?.backgroundInverse,
      textColor: carbonToken?.textInverse,
      title: const Text.rich(
        TextSpan(
          text: 'Powered by ',
          children: [
            TextSpan(
              text: 'UniVRse',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
