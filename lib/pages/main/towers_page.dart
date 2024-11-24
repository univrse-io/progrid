import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';
import 'package:progrid/components/my_loader.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:provider/provider.dart';

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
              "Query Towers",
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

            const Text(
              "   we found...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),

            // towers list (important)
            Expanded(
              child: towersProvider.towers.isEmpty
                  ? const Center(child: MyLoadingIndicator())
                  : ListView.builder(
                      itemCount: towersProvider.towers.length,
                      itemBuilder: (context, index) {
                        final tower = towersProvider.towers[index];
                        return GestureDetector(
                          onTap: () {
                            // TODO: navigate to dedicated tower page
                            print("Tapped on tower: ${tower.id}");
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SafeArea(
                              minimum: EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 70,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 16,
                                              height: 16,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: tower.status == 'active'
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              tower.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),

                                        // tower id and address
                                        Text(
                                          tower.address,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          tower.id,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 10,
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 44,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
