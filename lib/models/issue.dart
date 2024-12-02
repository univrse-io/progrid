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

  // factory builder, get from database
  factory Issue.fetchFromDatabase(DocumentSnapshot doc) {
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

  // update issue details
  Future<void> updateDetails(String towerId) async {
    await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('issues').doc(id).update(toMap());
  }

  // save issue to database, given tower id
  // Future<void> saveToDatabase(String towerId) async {
  //   try {
  //     final reference = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('issues').add(toMap());
  //     id = reference.id;
  //   } catch (e) {
  //     throw Exception("Error saving issue: $e");
  //   }
  // }
}