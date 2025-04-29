import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'issue_status.dart';

class Issue {
  String id;
  IssueStatus status;
  String authorId;
  Timestamp createdAt;
  Timestamp? updatedAt;
  String? authorName;
  String description;
  List<String> tags;

  Issue({
    required this.id,
    required this.status,
    required this.authorId,
    required this.createdAt,
    this.updatedAt,
    this.authorName,
    this.description = '',
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
    createdAt: json['createdAt'] as Timestamp? ?? json['dateTime'] as Timestamp,
    updatedAt: json['updatedAt'] as Timestamp?,
    authorName: json['authorName'] as String?,
    description: json['description'] as String,
    tags: (json['tags'] as List?)?.cast<String>() ?? [],
  );

  String get context =>
      '${updatedAt != null ? 'Updated' : 'Created'}'
      '${authorName != null ? ' by $authorName' : ''} at '
      '${DateFormat('MMM d, y').format(updatedAt != null ? updatedAt!.toDate() : createdAt.toDate())}';

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status.name,
    'authorId': authorId,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'authorName': authorName,
    'description': description,
    'tags': tags,
  };
}
