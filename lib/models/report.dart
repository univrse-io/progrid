// Report Model
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  String id;
  Timestamp dateTime;
  String authorId;
  String authorName;
  List<String> images;
  String notes;

  // constructor
  Report({
    this.id = '', // will be filled when created in firestore
    required this.dateTime,
    required this.authorId,
    required this.authorName,
    this.images = const [], // default empty
    this.notes = 'no notes', // default
  });

  // format for database
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'authorId': authorId,
      'authorName': authorName,
      'notes': notes,
      'images': images,
    };
  }

  // factory builder, get from database
  factory Report.fetchFromDatabase(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return Report(
      id: doc.id,
      dateTime: data['dateTime'] as Timestamp,
      authorId: data['authorId'] as String,
      authorName: data['authorName'] as String,
      images: (data['images'] as List<dynamic>?)?.cast<String>() ?? [],
      notes: data['notes'] as String? ?? 'no notes',
    );
  }

  // save report to firestore given tower id
  Future<void> saveToDatabase(String towerId) async {
    try {
      final reference = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('reports').add(toMap());
      id = reference.id;
    } catch (e) {
      throw Exception("Error saving report: $e");
    }
  }
}