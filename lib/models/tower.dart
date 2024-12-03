// Tower Model (perfected)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/report.dart';

class Tower {
  String id;
  String name;
  String region;
  String type;
  String owner;
  String address;
  GeoPoint position;
  String status;
  String notes;

  Stream<List<Report>> reports;
  Stream<List<Issue>> issues;

  // List<Report> reports;
  // List<Issue> issues;

  // constructor
  Tower({
    this.id = 'undefined',
    this.name = 'undefined',
    this.region = 'undefined',
    this.type = 'undefined',
    this.owner = 'undefined',
    this.address = 'undefined',
    this.position = const GeoPoint(0, 0),
    this.status = 'undefined',
    this.notes = 'no notes',
    required this.reports,
    required this.issues,
  });

  // given a tower document, fetch from database
  static Tower fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    // set up report stream
    final Stream<List<Report>> reportsStream = FirebaseFirestore.instance
        .collection('towers')
        .doc(doc.id)
        .collection('reports')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList());

    // set up issue stream
    final Stream<List<Issue>> issuesStream = FirebaseFirestore.instance
        .collection('towers')
        .doc(doc.id)
        .collection('issues')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Issue.fromFirestore(doc)).toList());

    return Tower(
      id: doc.id, // Firebase document ID = tower ID
      name: data['name'] as String? ?? 'undefined',
      region: data['region'] as String? ?? 'undefined',
      type: data['type'] as String? ?? 'undefined',
      owner: data['owner'] as String? ?? 'undefined',
      address: data['address'] as String? ?? 'undefined',
      position: data['position'] is GeoPoint
          ? data['position'] as GeoPoint
          : GeoPoint(0, 0), // fix
      status: data['status'] as String? ?? 'undefined',
      notes: data['notes'] as String? ?? 'no notes',
      reports: reportsStream,
      issues: issuesStream,
    );
  }

  // add report to tower
  Future<void> addReport(Report report) async {
    await FirebaseFirestore.instance
        .collection('towers')
        .doc(id)
        .collection('reports')
        .add(report.toMap());
    // also update status to 'surveyed'
    await FirebaseFirestore.instance.collection('towers').doc(id).update({'status': 'surveyed'});
  }

  // add an issue to tower
  Future<void> addIssue(Issue issue) async {
    await FirebaseFirestore.instance
        .collection('towers')
        .doc(id)
        .collection('issues')
        .add(issue.toMap());
  }

  Future<void> updateIssueStatus(String issueId, String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('towers')
          .doc(id)
          .collection('issues')
          .doc(issueId)
          .update({'status': status});
    } catch (e) {
      print("Error updating issue status in tower: $e");
    }
  }
}
