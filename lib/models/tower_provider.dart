import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Tower Model
class Tower {
  String towerId = 'undefined';
  String name = 'undefined';
  String address = 'undefined';
  String status = 'undefined';
  String notes = 'NaN';

  // TODO: implement ticket objects (inspection and issues)

  // constructor
  Tower({
    required this.towerId,
    required this.name,
    required this.address,
    required this.status,
    required this.notes,
  });

  factory Tower.fetchTowerInfoFromDatabase(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Tower(
      towerId: doc.id,
      name: data['name'] ?? 'undefined',
      address: data['address'] ?? 'undefined',
      status: data['status'] ?? 'undefined',
      notes: data['notes'] ?? 'NaN',
    );
  }
}

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];

  // run this to refresh towers list
  Future<void> fetchTowers() async {
    try {
      towers = []; // reset list
      final snapshot = await FirebaseFirestore.instance.collection('towers').get();

      // fetch each tower
      for (var doc in snapshot.docs) {
        Tower tower = Tower.fetchTowerInfoFromDatabase(doc);
        towers.add(tower);
      }
      notifyListeners();
    } catch (e) {
      print("Error Fetching Towers: $e");
    }
  }

  // returns a formatted widget list of towers
  Widget buildTowersList(BuildContext context) {
    if (towers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: towers.length,
      itemBuilder: (context, index) {
        var tower = towers[index];

        return GestureDetector(
          onTap: () {
            // TODO: navigate to dedicated tower page
            print("Tapped on tower: ${tower.name}");
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SafeArea(
              minimum: const EdgeInsets.all(15),
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
                                color: tower.status == 'active' ? Colors.green : Colors.red,
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
                        Text(tower.address, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 3),
                        Text(tower.towerId, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  const Expanded(
                      flex: 10,
                      child: Icon(
                        Icons.arrow_right,
                        size: 44,
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
