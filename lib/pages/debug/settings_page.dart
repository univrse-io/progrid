import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';
import 'package:progrid/components/my_textfield.dart';
import 'package:progrid/models/user_provider.dart';

import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _phoneController = TextEditingController();
  final _altEmailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    _phoneController.text = userProvider.phone;
    _altEmailController.text = userProvider.altEmail;
  }

  Future<void> _updateUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in!')),
      );
      return;
    }

    try {
      // update Firestore document
      FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'phone': _phoneController.text.trim(),
        'altEmail': _altEmailController.text.trim(),
      });

      // update local provider
      userProvider.phone = _phoneController.text.trim();
      userProvider.altEmail = _altEmailController.text.trim();
      // TODO: create setter functions for above
      // should call notify listeners after updating

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Information updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update information: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              "Edit Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),

            // phone field
            MyTextField(
              controller: _phoneController,
              hintText: 'Phone Number',
            ),
            const SizedBox(height: 10),

            // alternate email field
            MyTextField(
              controller: _altEmailController,
              hintText: 'Alternate Email',
            ),
            const SizedBox(height: 10),

            MyButton(
              text: 'Save Changes',
              onTap: _updateUserInfo,
              height: 45,
            ),
            const SizedBox(height: 10),

            // logout
            MyButton(
              text: 'Logout',
              onTap: userProvider.logout,
              height: 45,
            ),
          ],
        ),
      ),
    );
  }
}
