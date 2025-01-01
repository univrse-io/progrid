import 'package:cloud_firestore/cloud_firestore.dart';

class Issue {
  String id;
  // TODO: Change the field type from String to [IssueStatus] enum.
  String status;
  Timestamp dateTime;
  String authorId;
  String description;
  List<String> tags;

  Issue({
    required this.id,
    required this.status,
    required this.dateTime,
    required this.authorId,
    this.description = 'no description',
    this.tags = const [],
  });

  /// Converts an [Issue] instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'dateTime': dateTime,
        'authorId': authorId,
        'description': description,
        'tags': tags,
      };

  /// Converts the [Issue] instance to a JSON object.
  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
      id: json['id'] as String,
      status: json['status'] as String,
      dateTime: json['dateTime'] as Timestamp,
      authorId: json['authorId'] as String,
      description: json['description'] as String,
      tags: (json['tags'] as List?)?.cast<String>() ?? []);

  /// Creates an [Issue] instance from a Firestore document.
  factory Issue.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    data['id'] = doc.id;

    return Issue.fromJson(data);
  }
}
