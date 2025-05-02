import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_auth_service.dart';
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
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    /// TODO: Insert company related image on the background.
    appBar: AppBar(title: Image.asset('assets/images/progrid.png', height: 35)),
    body: SizedBox(
      width: 480,
      child: PageView(
        controller: pageController,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacing.$6(),
                Text('Welcome back!', style: CarbonTextStyle.heading05),
                const Spacing.$2(),
                Row(
                  children: [
                    const Text('Not a member? '),
                    CarbonLink.inline(
                      onPressed: () => pageController.jumpToPage(1),
                      label: 'Register',
                    ),
                  ],
                ),
                const Spacing.$6(),
                const Divider(),
                const Spacing.$6(),
                // TODO: Validate email address input.
                CarbonTextInput(
                  controller: emailController,
                  labelText: 'Email',
                  textInputAction: TextInputAction.next,
                ),
                const Spacing.$3(),
                CarbonTextInput(
                  controller: passwordController,
                  labelText: 'Password',
                  obscureText: true,
                ),
                const Spacing.$3(),
                // TODO: Implement remember me functionality.
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      visualDensity: VisualDensity.compact,
                      onChanged: (val) {
                        if (val != null) setState(() => rememberMe = val);
                      },
                    ),
                    const Text('Remember Me'),
                    const Spacer(),
                    CarbonLink(
                      onPressed: () => pageController.jumpToPage(2),
                      label: 'Forgot Password?',
                    ),
                  ],
                ),
                const Spacing.$6(),
                CarbonPrimaryButton(
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
                  label: 'Login',
                  icon: CarbonIcon.arrow_right,
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
