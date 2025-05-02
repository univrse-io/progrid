import 'dart:async';
import 'dart:developer';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// TODO: Customize UI to fit large screen like webpages.
class EmailVerificationPage extends StatefulWidget {
  const EmailVerificationPage({super.key});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late final user = Provider.of<User?>(context, listen: false);
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (_) => user?.reload());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Spacer(),
          const Text(
            'We have sent a verification email to your registered email address. '
            'Please verify your email to proceed.',
            textAlign: TextAlign.center,
          ),
          const Spacer(),
          CarbonPrimaryButton(
            onPressed: () async {
              try {
                await user?.sendEmailVerification();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Verification email has been sent!'),
                    ),
                  );
                }
              } on FirebaseAuthException catch (e) {
                log('Failed to resend verification email. $e', error: e);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Oops, sorry! ${e.message}')),
                  );
                }
              }
            },
            label: 'Resend verification email',
          ),
          const Spacing.$5(),
          CarbonSecondaryButton(
            onPressed: FirebaseAuth.instance.signOut,
            label: 'Back to login',
          ),
        ],
      ),
    ),
  );
}
