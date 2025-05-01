import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'issue_status.dart';

class Issue {
  String id;
  IssueStatus status;
  String authorId;
  String notes;
  Timestamp createdAt;
  Timestamp? updatedAt;
  String? authorName;
  List<String> tags;

  Issue({
    required this.id,
    required this.status,
    required this.authorId,
    required this.notes,
    required this.createdAt,
    this.updatedAt,
    this.authorName,
    this.tags = const [],
  });

  factory Issue.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    data['id'] = doc.id;

    return Issue.fromJson(data);
  }

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
    id: json['id'] as String,
    status: IssueStatus.values.byName((json['status'] as String).toLowerCase()),
    authorId: json['authorId'] as String,
    notes: json['notes'] as String? ?? json['description'] as String,
    createdAt: json['createdAt'] as Timestamp? ?? json['dateTime'] as Timestamp,
    updatedAt: json['updatedAt'] as Timestamp?,
    authorName: json['authorName'] as String?,
    tags: (json['tags'] as List?)?.cast<String>() ?? [],
  );

  String get description =>
      '${updatedAt != null ? 'Updated' : 'Created'}'
      '${authorName != null ? ' by $authorName' : ''} at '
      '${DateFormat().format(updatedAt != null ? updatedAt!.toDate() : createdAt.toDate())}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status.name,
    'authorId': authorId,
    'notes': notes,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'authorName': authorName,
    'tags': tags,
  };

  @override
  String toString() =>
      'Issue(id=$id, status=$status, authorId=$authorId, notes=$notes, '
      'createdAt=$createdAt, updatedAt=$updatedAt, authorName=$authorName, '
      'tags=$tags)';
}
