import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController;
  final PageController pageController;

  const ForgotPasswordPage({
    required this.emailController,
    required this.pageController,
    super.key,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Spacing.$7(),
        Text('Reset password', style: CarbonTextStyle.heading05),
        const Spacing.$2(),
        Row(
          children: [
            const Text('Now you remember? '),
            CarbonLink(
              onPressed: () => pageController.jumpToPage(0),
              label: 'Return',
              isInline: true,
            ),
          ],
        ),
        const Spacing.$7(),
        const Divider(),
        const Spacing.$5(),
        // TODO: Validate email input.
        CarbonTextInput(controller: emailController, labelText: 'Email'),
        const Spacing.$5(),
        FilledButton(
          // TODO: Restructure forgot password function.
          onPressed: () async {
            final email = emailController.text.trim();

            if (email.isEmpty) {
              unawaited(
                showDialog(
                  context: context,
                  builder:
                      (_) => const AlertDialog(
                        title: Text('Please Enter an Email Address'),
                      ),
                ),
              );
              return;
            }

            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

              if (context.mounted) {
                unawaited(
                  showDialog(
                    context: context,
                    builder:
                        (_) => const AlertDialog(
                          title: Text(
                            'Password reset email sent. Check your inbox',
                          ),
                        ),
                  ),
                );
              }
            } on FirebaseAuthException catch (e) {
              if (context.mounted) {
                unawaited(
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(title: Text(e.message!)),
                  ),
                );
              }
            }
          },
          child: const Text('Confirm'),
        ),
      ],
    ),
  );
}
