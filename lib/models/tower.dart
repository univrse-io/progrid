import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'drawing_status.dart';
import 'region.dart';
import 'survey_status.dart';

// TODO: Restructure the tower model.
class Tower {
  String id;
  String name;
  Region region;
  String type;
  String owner = 'null';
  String address;
  GeoPoint position;
  SurveyStatus surveyStatus;
  DrawingStatus? drawingStatus;
  List<String> images;
  Timestamp? signIn;
  Timestamp? signOut;
  String? authorId;
  String? notes;
  // String? base;
  // String? equipmentShelter;

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
    // this.base,
    // this.equipmentShelter
  });

  factory Tower.fromJson(Map<String, dynamic> json) => Tower(
    id: json['id'] as String,
    name: json['name'] as String,
    region: Region.values.byName((json['region'] as String).toLowerCase()),
    type: json['type'] as String,
    owner: (json['owner'] as String?) ?? 'no owner',
    address: json['address'] as String,
    position: json['position'] as GeoPoint,
    surveyStatus: SurveyStatus.values.byName(
      (json['surveyStatus'] as String)
          .replaceAll(RegExp(r'[\s-]'), '')
          .toLowerCase(),
    ),
    drawingStatus:
        json['drawingStatus'] != null
            ? DrawingStatus.values.byName(
              (json['drawingStatus'] as String)
                  .replaceAll(RegExp(r'[\s-]'), '')
                  .toLowerCase(),
            )
            : null,
    images: (json['images'] as List?)?.cast<String>() ?? [],
    signIn: json['signIn'] as Timestamp?,
    signOut: json['signOut'] as Timestamp?,
    authorId: json['authorId'] as String?,
    notes: json['notes'] as String?,
    // base: json['base'] as String?,
    // equipmentShelter: json['equipmentShelter'] as String?,
  );

  factory Tower.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    data['id'] = doc.id;

    return Tower.fromJson(data);
  }

  String get context => switch (surveyStatus) {
    SurveyStatus.surveyed =>
      'Signed-out${signOut != null ? ' at ${DateFormat('MMM d, y').format(signOut!.toDate())}' : ''}',
    SurveyStatus.inprogress =>
      'Signed-in${signIn != null ? ' at ${DateFormat('MMM d, y').format(signIn!.toDate())}' : ''}',
    _ => 'To be surveyed',
  };
}
