import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'drawing_status.dart';
import 'region.dart';
import 'survey_status.dart';

class Tower {
  String id;
  String name;
  Region region;
  String type;
  String address;
  GeoPoint position;
  SurveyStatus surveyStatus;
  DrawingStatus? drawingStatus;
  List<String> images;
  String? authorId;
  String? authorName;
  String? owner;
  String? notes;
  Timestamp? signIn;
  Timestamp? signOut;
  Timestamp? updatedAt;

  Tower({
    required this.id,
    required this.name,
    required this.region,
    required this.type,
    required this.address,
    required this.position,
    required this.surveyStatus,
    required this.drawingStatus,
    required this.images,
    this.authorId,
    this.authorName,
    this.owner,
    this.notes,
    this.signIn,
    this.signOut,
    this.updatedAt,
  });

  factory Tower.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    data['id'] = doc.id;

    return Tower.fromJson(data);
  }

  factory Tower.fromJson(Map<String, dynamic> json) => Tower(
    id: json['id'] as String,
    name: json['name'] as String,
    region: Region.values.byName((json['region'] as String).toLowerCase()),
    type: json['type'] as String,
    address: json['address'] as String,
    position: json['position'] as GeoPoint,
    surveyStatus: SurveyStatus.values.byName(json['surveyStatus'] as String),
    drawingStatus:
        json['drawingStatus'] != null
            ? DrawingStatus.values.byName(json['drawingStatus'] as String)
            : null,
    images: (json['images'] as List?)?.cast<String>() ?? [],
    authorId: json['authorId'] as String?,
    authorName: json['authorName'] as String?,
    owner: json['owner'] as String?,
    notes: json['notes'] as String?,
    signIn: json['signIn'] as Timestamp?,
    signOut: json['signOut'] as Timestamp?,
    updatedAt: json['updatedAt'] as Timestamp?,
  );

  String get context => switch (surveyStatus) {
    SurveyStatus.surveyed =>
      'Signed out'
          '${authorName != null ? ' by $authorName' : ''}'
          '${signOut != null ? ' at ${DateFormat().format(signOut!.toDate())}' : ''}',
    SurveyStatus.inprogress =>
      'Signed in'
          '${authorName != null ? ' by $authorName' : ''}'
          '${signIn != null ? ' at ${DateFormat().format(signIn!.toDate())}' : ''}',
    _ =>
      updatedAt != null
          ? 'Updated'
              '${authorName != null ? ' by $authorName' : ''} at '
              '${DateFormat().format(updatedAt!.toDate())}'
          : 'To be surveyed',
  };

  @override
  String toString() =>
      'Tower(id=$id, name=$name, region=$region, type=$type, address=$address '
      'position=Geopoint(latitude=${position.latitude}, '
      'longitude=${position.longitude}), surveyStatus=$surveyStatus, '
      'drawingStatus=$drawingStatus, images=$images, authorId=$authorId, '
      'authorName=$authorName, owner=$owner, notes=$notes, signIn=$signIn, '
      'signOut=$signOut, updatedAt=$updatedAt)';
}
