import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserVerificationPage extends StatefulWidget {
  const UserVerificationPage({super.key});

  @override
  State<UserVerificationPage> createState() => _UserVerificationPageState();
}

class _UserVerificationPageState extends State<UserVerificationPage> {
  late User _user;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _checkIfVerifiedPeriodically();
  }

  void _checkIfVerifiedPeriodically() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 5));
      await _user.reload();
      if (_user.emailVerified) return false;
      return true;
    });
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isResending = true;
    });
    try {
      await _user.sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email has been sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending email: $e')),
        );
      }
    } finally {
      setState(() {
        _isResending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'We have sent a verification email to your registered email address. Please verify your email to proceed.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          if (_isResending)
            const CircularProgressIndicator()
          else
            FilledButton(
              onPressed: _resendVerificationEmail,
              child: const Text('Resend Verification Email'),
            ),
          const SizedBox(height: 0),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            child: const Text(
              'Back to Log In',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    ));
  }
}
