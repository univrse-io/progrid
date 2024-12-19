// Tower Model (perfected)
import 'package:cloud_firestore/cloud_firestore.dart';

class Tower {
  String id;
  String name;
  String region;
  String type;
  String owner;
  String address;
  GeoPoint position;
  String status;
  String drawingStatus;
  String notes;

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
    this.drawingStatus = 'undefined',
    this.notes = 'no notes',
  });

  // given a tower document, fetch from database
  static Future<Tower> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data()! as Map<String, dynamic>;
    return Tower(
      id: doc.id,
      name: data['name'] as String? ?? 'undefined',
      region: data['region'] as String? ?? 'undefined',
      type: data['type'] as String? ?? 'undefined',
      owner: data['owner'] as String? ?? 'undefined',
      address: data['address'] as String? ?? 'undefined',
      position: data['position'] is GeoPoint
          ? data['position'] as GeoPoint
          : GeoPoint(0, 0),
      status: data['status'] as String? ?? 'undefined',
      drawingStatus: data['drawingStatus'] as String? ?? 'undefined',
      notes: data['notes'] as String? ?? 'no notes',
    );
  }
}
