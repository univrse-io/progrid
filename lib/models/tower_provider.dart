import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Tower Model
class Tower {
  String id;
  String name;
  String region;
  String type;
  String owner;
  String address;
  GeoPoint position;
  String status;
  String notes;

  // TODO: implement ticket objects (inspection and issues)

  // constructor
  Tower({
    this.id = 'undefined',
    this.name = 'undefined',
    this.region = 'undefined',
    this.type = 'undefined',
    this.owner = 'undefined',
    this.address = 'undefined',
    this.position = const GeoPoint(0, 0),
    this.status = 'undefined',
    this.notes = 'no notes',
  });

  // given a tower document, fetch from database
  factory Tower.fetchTowerInfoFromDatabase(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Tower(
      id: doc.id, // firebase document id = tower id
      name: data['name'] as String? ?? 'undefined',
      region: data['region'] as String? ?? 'undefined',
      type: data['type'] as String? ?? 'undefined',
      owner: data['owner'] as String? ?? 'undefined',
      address: data['address'] as String? ?? 'undefined',
      position: data['position'] is GeoPoint
          ? data['position'] as GeoPoint
          : GeoPoint(0, 0), // fix
      status: data['status'] as String? ?? 'undefined',
      notes: data['notes'] as String? ?? 'no notes',
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
      for (final doc in snapshot.docs) {
        final Tower tower = Tower.fetchTowerInfoFromDatabase(doc);
        towers.add(tower);
      }
      notifyListeners();
    } catch (e) {
      print("Error Fetching Towers: $e");
    }
  }

  // returns a formatted widget list of towers
  // TODO: move this to it's own page, dont implement here
  Widget buildTowersList(BuildContext context) {
    if (towers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: towers.length,
      itemBuilder: (context, index) {
        final tower = towers[index];

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
                        Text(tower.id, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
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
