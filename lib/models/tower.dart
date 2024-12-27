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

  Tower(
      {required this.id,
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
      this.notes});

  /// Creates a [Tower] instance from a JSON object.
  ///
  /// This method extracts the data from the provided [json]
  /// and maps it to the corresponding fields of the [Tower] model.
  factory Tower.fromJson(Map<String, dynamic> json) => Tower(
      id: json['id'] as String,
      name: json['name'] as String,
      region: json['region'] as String,
      type: json['type'] as String,
      owner: json['owner'] as String,
      address: json['address'] as String,
      position: json['position'] as GeoPoint,
      surveyStatus: json['surveyStatus'] as String,
      drawingStatus: json['drawingStatus'] as String,
      images: (json['images'] as List?)?.cast<String>() ?? [],
      signIn: json['signIn'] as Timestamp?,
      signOut: json['signOut'] as Timestamp?,
      authorId: json['authorId'] as String?,
      notes: json['notes'] as String?);

  /// Creates a [Tower] instance from a Firestore document.
  ///
  /// This method extracts the data from the provided [DocumentSnapshot]
  /// and maps it to the corresponding fields of the [Tower] model.
  factory Tower.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>..addAll({'id': doc.id});

    return Tower.fromJson(data);
  }
}
