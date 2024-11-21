import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:progrid/components/my_button.dart';
import 'package:progrid/models/tower_provider.dart';

class TowersPage extends StatelessWidget {
  const TowersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Towers List",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 16),
            
            // refresh button (to be replaced with downward gesture)
            MyButton(
              text: "Refresh Towers",
              onTap: towersProvider.fetchTowers,
            ),
            const SizedBox(height: 20),

            Expanded(child: towersProvider.buildTowersList(context)),
          ],
        ),
      ),
    );

    // return const Center(child: Text("Towers Page"),);
  }
}