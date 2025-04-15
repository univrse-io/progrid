import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final carbonToken = Theme.of(context).extension<CarbonToken>();
  final emailController = TextEditingController();

  // TODO: Restructure forgot password function.
  Future<void> forgotPassword() async {
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
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Image.asset('assets/images/progrid_black.png', height: 35),
    ),
    body: SingleChildScrollView(
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
                onPressed: Navigator.of(context).pop,
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
          FilledButton(onPressed: forgotPassword, child: const Text('Confirm')),
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
