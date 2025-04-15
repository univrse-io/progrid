import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Image.asset('assets/images/progrid_black.png', height: 35),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacing.$7(),
          Text('Welcome Back!', style: CarbonTextStyle.heading05),
          const Spacing.$2(),
          Row(
            children: [
              const Text('Not a member? '),
              CarbonLink(
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    ),

                label: 'Register Now',
                isInline: true,
              ),
            ],
          ),
          const Spacing.$7(),
          const Divider(),
          const Spacing.$5(),
          CarbonTextInput(controller: emailController, labelText: 'Email'),
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
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    ),
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
                              (_) =>
                                  AlertDialog(title: Text(e.message ?? e.code)),
                        );
                      }
                      passwordController.clear();
                    }),
            child: const Text('Login'),
          ),
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
