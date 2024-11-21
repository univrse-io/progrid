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

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tower ID: ${tower.towerId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 10),
                Text('Name: ${tower.name}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Address: ${tower.address}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Status: ${tower.status}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 8),
                Text('Notes: ${tower.notes}', style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}
