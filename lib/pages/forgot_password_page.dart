import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  final PageController pageController;

  const ForgotPasswordPage(this.pageController, {super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage>
    with AutomaticKeepAliveClientMixin {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacing.$6(),
          Text('Reset password', style: CarbonTextStyle.heading05),
          const Spacing.$2(),
          Row(
            children: [
              const Text('Now you remember? '),
              CarbonLink.inline(
                onPressed: () => widget.pageController.jumpToPage(0),
                label: 'Return',
              ),
            ],
          ),
          const Spacing.$6(),
          const Divider(),
          const Spacing.$6(),
          // TODO: Validate email address input.
          CarbonTextInput(controller: emailController, labelText: 'Email'),
          const Spacing.$6(),
          CarbonPrimaryButton(
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
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: email,
                );

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
            label: 'Confirm',
          ),
        ],
      ),
    );
  }
}
