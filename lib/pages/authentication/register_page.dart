import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final PageController pageController;
  final GlobalKey<FormState> formKey;

  const RegisterPage({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.pageController,
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Form(
    key: formKey,
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacing.$7(),
          Text('Hello there!', style: CarbonTextStyle.heading05),
          const Spacing.$2(),
          Row(
            children: [
              const Text('Have an account? '),
              CarbonLink(
                onPressed: () => pageController.jumpToPage(0),
                label: 'Login',
                isInline: true,
              ),
            ],
          ),
          const Spacing.$7(),
          const Divider(),
          const Spacing.$5(),
          CarbonTextInput(
            controller: nameController,
            labelText: 'Full Name',
            maxCharacters: 20,
          ),
          const Spacing.$3(),
          // TODO: Validate email input.
          CarbonTextInput(controller: emailController, labelText: 'Email'),
          const Spacing.$3(),
          CarbonTextInput(
            controller: passwordController,
            labelText: 'Password',
            obscureText: true,
          ),
          const Spacing.$3(),
          CarbonTextInput(
            labelText: 'Confirm Password',
            obscureText: true,
            validator:
                (value) =>
                    passwordController.text != value
                        ? "Passwords don't match"
                        : null,
          ),
          const Spacing.$5(),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              FirebaseAuthService()
                  .register(
                    nameController.text.trim(),
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  )
                  .onError<FirebaseAuthException>((e, _) {
                    if (context.mounted) {
                      unawaited(
                        showDialog(
                          context: context,
                          builder:
                              (_) =>
                                  AlertDialog(title: Text(e.message ?? e.code)),
                        ),
                      );
                    }
                  })
                  .then((_) => pageController.jumpTo(0));
            },
            child: const Text('Register'),
          ),
        ],
      ),
    ),
  );
}
