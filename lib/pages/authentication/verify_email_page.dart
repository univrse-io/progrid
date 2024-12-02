import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailPage extends StatefulWidget {
  final User user;
  const VerifyEmailPage({super.key, required this.user});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool _emailSent = false;

  Future<void> _sendVerificationEmail() async {
    try {
      await widget.user.sendEmailVerification();
      setState(() {
        _emailSent = true;
      });
    } catch (e) {
      print("Error sending email verification: $e");
    }
  }

  Future<void> _checkEmailVerified() async {
    await widget.user.reload();
    if (widget.user.emailVerified) {
      if (mounted) Navigator.pop(context); // go back
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email not verified yet. Please try again later."),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Your Email"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "A verification email has been sent to your email address. Please verify your email to continue.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            if (!_emailSent)
              ElevatedButton(
                onPressed: _sendVerificationEmail,
                child: const Text("Resend Verification Email"),
              ),
            if (_emailSent)
              const Text(
                "Verification email sent! Check your inbox.",
                style: TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkEmailVerified,
              child: const Text("I Have Verified"),
            ),
          ],
        ),
      ),
    );
  }
}
