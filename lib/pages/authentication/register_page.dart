import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    late final carbonToken = Theme.of(context).extension<CarbonToken>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/progrid_black.png', height: 35),
      ),
      body: Form(
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
                    onPressed: Navigator.of(context).pop,
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
                                  (_) => AlertDialog(
                                    title: Text(e.message ?? e.code),
                                  ),
                            ),
                          );
                        }
                      })
                      .then((_) {
                        if (context.mounted) Navigator.pop(context);
                      });
                },
                child: const Text('Register'),
              ),
            ],
          ),
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
}
