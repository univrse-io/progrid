import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/models/user_provider.dart';
import 'package:provider/provider.dart';

// Server-Side Debug Interface
class DebugHomePage extends StatelessWidget {
  const DebugHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    var towers = TowerService().getTowers();

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Marcel's Debug Home Page",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),

            Text("Email: ${userProvider.user?.email ?? "No Email"}"),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: towers.length,
                itemBuilder: (context, index) {
                  var tower = towers[index];
                  var inspections = tower.inspections;
                  var issues = tower.issues;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      title: Text(tower.towerId),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${tower.status}'),
                          if (inspections.isNotEmpty) Text('Inspection Ticket Count: ${inspections.length}'),
                          if (issues.isNotEmpty) Text('Issue Ticket Count: ${issues.length}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.onSurface),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // logout button
            MyButton(
              onTap: FirebaseAuth.instance.signOut,
              text: "Logout",
            ),
          ],
        ),
      ),
    );
  }
}
