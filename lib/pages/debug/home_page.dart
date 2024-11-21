import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:progrid/components/my_button.dart';
import 'package:progrid/models/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      minimum: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Developer Home Page",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 10),

          // TODO: move datetime formatting to user class itself
          Text("UserID: ${userProvider.userId}"),
          Text(
            "Last Login: ${userProvider.lastLogin != null ? '${DateFormat('yyyy-MM-dd HH:mm:ss').format(userProvider.lastLogin!.toDate().toUtc().add(const Duration(hours: 7)))} UTC+7' : 'Not Available'}",
          ),
          Text("Email: ${userProvider.email}"),
          Text("Account Type: ${userProvider.role}"),

          const SizedBox(height: 20),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
