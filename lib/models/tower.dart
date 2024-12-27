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
  String surveyStatus;
  String drawingStatus;
  List<String> images;
  Timestamp? signIn;
  Timestamp? signOut;
  String? authorId;
  String? notes;

  Tower({
    required this.id,
    required this.name,
    required this.region,
    required this.type,
    required this.owner,
    required this.address,
    required this.position,
    required this.surveyStatus,
    required this.drawingStatus,
    required this.images,
    this.signIn,
    this.signOut,
    this.authorId,
    this.notes,
  });

  // TODO: Create a fromJson method that takes a Map<String, dynamic> and returns a Tower instance.

  /// Creates a [Tower] instance from a Firestore document.
  ///
  /// This method extracts the data from the provided [DocumentSnapshot]
  /// and maps it to the corresponding fields of the [Tower] model.
  static Tower fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return Tower(
      id: doc.id,
      name: data['name'] as String,
      region: data['region'] as String,
      type: data['type'] as String,
      owner: data['owner'] as String,
      address: data['address'] as String,
      position: data['position'] as GeoPoint,
      surveyStatus: data['surveyStatus'] as String,
      drawingStatus: data['drawingStatus'] as String,
      images: (data['images'] as List?)?.cast<String>() ?? [],
      signIn: data['signIn'] as Timestamp?,
      signOut: data['signOut'] as Timestamp?,
      authorId: data['authorId'] as String?,
      notes: data['notes'] as String?,
    );
  }
}
