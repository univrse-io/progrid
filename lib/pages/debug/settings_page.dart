import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';
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
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Profile',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // phone field
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // alternate email field
            TextField(
              controller: _altEmailController,
              decoration: const InputDecoration(
                labelText: 'Alternate Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            MyButton(
              text: 'Save Changes',
              onTap: _updateUserInfo,
            ),
            const SizedBox(height: 20),

            // logout
            MyButton(
              text: 'Logout',
              onTap: userProvider.logout,
            ),
          ],
        ),
      ),
    );
  }
}
