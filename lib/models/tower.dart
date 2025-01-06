import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progrid/models/drawing_status.dart';
import 'package:progrid/models/region.dart';
import 'package:progrid/models/survey_status.dart';

class Tower {
  String id;
  String name;
  Region region;
  String type;
  String owner;
  String address;
  GeoPoint position;
  // TODO: Change the field type from String to [SurveyStatus] enum.
  SurveyStatus surveyStatus;
  DrawingStatus drawingStatus;
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
  factory Tower.fromJson(Map<String, dynamic> json) => Tower(
      id: json['id'] as String,
      name: json['name'] as String,
      region: Region.values.byName((json['region'] as String).toLowerCase()),
      type: json['type'] as String,
      owner: json['owner'] as String,
      address: json['address'] as String,
      position: json['position'] as GeoPoint,
      // surveyStatus: json['surveyStatus'] as String,
      surveyStatus: SurveyStatus.values
          .byName((json['surveyStatus'] as String).toLowerCase()),
      drawingStatus: DrawingStatus.values
          .byName((json['drawingStatus'] as String).toLowerCase()),
      images: (json['images'] as List?)?.cast<String>() ?? [],
      signIn: json['signIn'] as Timestamp?,
      signOut: json['signOut'] as Timestamp?,
      authorId: json['authorId'] as String?,
      notes: json['notes'] as String?);

  /// Creates a [Tower] instance from a Firestore document.
  factory Tower.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    data['id'] = doc.id;

    return Tower.fromJson(data);
  }
}
