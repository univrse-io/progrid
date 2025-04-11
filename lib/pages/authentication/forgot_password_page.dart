import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  // forgot password
  Future<void> forgotPassword() async {
    final email = _emailController.text.trim();

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

      if (mounted) {
        Navigator.pop(context);
        unawaited(
          showDialog(
            context: context,
            builder:
                (_) => const AlertDialog(
                  title: Text('Password reset email sent. Check your inbox'),
                ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        unawaited(
          showDialog(
            context: context,
            builder: (_) => AlertDialog(title: Text(e.message!)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: SafeArea(
      child: Center(
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // forgot password text
              Text(
                'Forgot Password?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: forgotPassword,
                child: const Text('Confirm'),
              ),
              const SizedBox(height: 14),

              // back link
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  }, // go back to login
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
