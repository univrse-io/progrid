import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserVerificationPage extends StatefulWidget {
  const UserVerificationPage({super.key});

  @override
  State<UserVerificationPage> createState() => _UserVerificationPageState();
}

class _UserVerificationPageState extends State<UserVerificationPage> {
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
    body: SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'We have sent a verification email to your registered email address. Please verify your email to proceed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          FilledButton(
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
            child: const Text('Resend Verification Email'),
          ),
          TextButton(
            onPressed: FirebaseAuth.instance.signOut,
            child: const Text(
              'Back to Log In',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    ),
  );
}
