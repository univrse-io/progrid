import 'dart:async';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firebase_auth_service.dart';

class RegisterPage extends StatefulWidget {
  final PageController pageController;

  const RegisterPage(this.pageController, {super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();
  late final nameController =
      TextEditingController()..addListener(() => setState(() {}));
  late final emailController =
      TextEditingController()..addListener(() => setState(() {}));
  late final passwordController =
      TextEditingController()..addListener(() => setState(() {}));
  late final confirmPasswordController =
      TextEditingController()..addListener(() => setState(() {}));

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Spacing.$6(),
            Text('Hello there!', style: CarbonTextStyle.heading05),
            const Spacing.$2(),
            Row(
              children: [
                const Text('Have an account? '),
                CarbonLink.inline(
                  onPressed: () => widget.pageController.jumpToPage(0),
                  label: 'Login',
                ),
              ],
            ),
            const Spacing.$6(),
            const Divider(),
            const Spacing.$6(),
            CarbonTextInput(
              controller: nameController,
              labelText: 'Full Name',
              maxCharacters: 20,
              textInputAction: TextInputAction.next,
            ),
            const Spacing.$3(),
            // TODO: Validate email address input.
            CarbonTextInput(
              controller: emailController,
              labelText: 'Email',
              textInputAction: TextInputAction.next,
            ),
            const Spacing.$3(),
            CarbonTextInput(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
            ),
            const Spacing.$3(),
            CarbonTextInput(
              controller: confirmPasswordController,
              labelText: 'Confirm Password',
              obscureText: true,
              validator:
                  (value) =>
                      passwordController.text != value
                          ? "Passwords don't match"
                          : null,
            ),
            const Spacing.$6(),
            CarbonPrimaryButton(
              onPressed:
                  passwordController.text.isNotEmpty &&
                          passwordController.text ==
                              confirmPasswordController.text
                      ? () => FirebaseAuthService()
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
                      : null,
              label: 'Register',
              icon: CarbonIcon.arrow_right,
            ),
          ],
        ),
      ),
    );
  }
}
