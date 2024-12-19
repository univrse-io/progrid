// Report Model
import 'package:cloud_firestore/cloud_firestore.dart';

class Record {
  String id;
  // Timestamp dateTime;
  Timestamp createdAt;
  Timestamp? closedAt;
  String authorId;
  List<String> images;
  String notes;

  // constructor
  Record({
    this.id = '', // will be filled on creation
    required this.createdAt,
    this.closedAt,
    required this.authorId,
    this.images = const [], // default empty
    this.notes = 'no notes', // default
  });

  // TODO: REVIEW, MAY HAVE TO INCLUDE SIGN IN SIGN OUT IN ONE

  // format function
  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'closedAt': closedAt, // nullable
      'authorId': authorId,
      'notes': notes,
      'images': images,
    };
  }

  // factory builder: given a document, return a report instance
  factory Record.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return Record(
      id: doc.id,
      createdAt: data['createdAt'] as Timestamp,
      closedAt: data['closedAt'] as Timestamp?,
      authorId: data['authorId'] as String,
      images: (data['images'] as List<dynamic>?)?.cast<String>() ?? [],
      notes: data['notes'] as String? ?? 'no notes',
    );
  }
}
