// Report Model
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String id;
  Timestamp dateTime;
  String authorId;
  List<String> images;
  String notes;

  // constructor
  Report({
    this.id = '', // will be filled when created in firestore
    required this.dateTime,
    required this.authorId,
    this.images = const [], // default empty
    this.notes = 'no notes', // default
  });

  // format for database
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'authorId': authorId,
      'notes': notes,
      'images': images,
    };
  }

  // factory builder: given a document, return a report instance
  factory Report.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return Report(
      id: doc.id,
      dateTime: data['dateTime'] as Timestamp,
      authorId: data['authorId'] as String,
      images: (data['images'] as List<dynamic>?)?.cast<String>() ?? [],
      notes: data['notes'] as String? ?? 'no notes',
    );
  }
}