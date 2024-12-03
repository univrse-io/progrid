// Issue Model
import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  String id;
  String status;
  Timestamp dateTime;
  String authorId;
  String description;
  List<String> tags;

  // constructor
  Issue({
    this.id = '',
    required this.status,
    required this.dateTime,
    required this.authorId,
    this.description = 'no description',
    this.tags = const [],
  });

  // format for database
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'dateTime': dateTime,
      'authorId': authorId,
      'description': description,
      'tags': tags,
    };
  }

  // factory builder: given a document, return an issue instance
  factory Issue.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return Issue(
      id: doc.id,
      status: data['status'] as String,
      dateTime: data['dateTime'] as Timestamp,
      authorId: data['authorId'] as String,
      description: data['description'] as String? ?? 'no description',
      tags: data['tags'] != null ? List<String>.from(data['tags'] as List<dynamic>) : [],
    );
  }
}
