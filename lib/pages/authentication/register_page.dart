import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firestore.dart';
import '../../utils/themes.dart';

class RegisterPage extends StatefulWidget {
  // toggle to login page
  final void Function()? onTapSwitchPage;

  const RegisterPage({required this.onTapSwitchPage, super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    // validate forms
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    // create the user
    try {
      final credentials =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // send verification email
      unawaited(credentials.user!.sendEmailVerification());

      await FirestoreService.createUser(
        credentials.user!.uid,
        data: {
          'email': _emailController.text.trim(),
          'name': _nameController.text,
          'phone': 'not set',
          'team': 'not set',
          'role': 'engineer',
          'lastLogin': Timestamp.now(),
        },
      );

      // add to firebase
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        unawaited(
          showDialog(
            context: context,
            builder: (_) => AlertDialog(title: Text(e.code)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          minimum: const EdgeInsets.all(20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/progrid_black.png', width: 300),
                  const SizedBox(height: 15),
                  Container(
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
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Welcome!\nCreate an Account.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Full Name',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              maxLength: 20,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              controller: _confirmPasswordController,
                              validator: (value) =>
                                  _passwordController.text != value
                                      ? "Passwords don't match"
                                      : null,
                            ),
                            const SizedBox(height: 24),
                            FilledButton(
                              onPressed: _register,
                              child: const Text('Register'),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Have an account? ',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: widget.onTapSwitchPage,
                                  child: Text(
                                    'Login Now',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // logos bottom set
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // sapura logo
                      Image.asset(
                        'assets/images/sapura.png',
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),

                      // binasat logo
                      Image.asset(
                        'assets/images/binasat.png',
                        width: 55,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),

                      // uos logo
                      Image.asset(
                        'assets/images/uos.png',
                        width: 55,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Powered by ',
                        style: TextStyle(color: AppColors.onSurface),
                      ),
                      Text(
                        'UniVRse',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
