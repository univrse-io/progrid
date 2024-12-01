// Tower Model
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

  List<Report> reports;
  List<Issue> issues;

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
    this.reports = const [],
    this.issues = const [],
  });

  // given a tower document, fetch from database
  static Future<Tower> fetchFromDatabase(DocumentSnapshot doc) async {
    final data = doc.data()! as Map<String, dynamic>;

    // fetch reports
    final List<Report> reports = await fetchReports(doc.id);
    final List<Issue> issues = await fetchIssues(doc.id);

    return Tower(
      id: doc.id, // firebase document id = tower id
      name: data['name'] as String? ?? 'undefined',
      region: data['region'] as String? ?? 'undefined',
      type: data['type'] as String? ?? 'undefined',
      owner: data['owner'] as String? ?? 'undefined',
      address: data['address'] as String? ?? 'undefined',
      position: data['position'] is GeoPoint ? data['position'] as GeoPoint : GeoPoint(0, 0), // fix
      status: data['status'] as String? ?? 'undefined',
      notes: data['notes'] as String? ?? 'no notes',
      reports: reports,
      issues: issues,
    );
  }

  // fetch tower reports
  static Future<List<Report>> fetchReports(String towerId) async {
    final snapshot = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('reports').get();
    return snapshot.docs.map((doc) => Report.fetchFromDatabase(doc)).toList();
  }

  // fetch tower issues
  static Future<List<Issue>> fetchIssues(String towerId) async {
    final snapshot = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('issues').get();
    return snapshot.docs.map((doc) => Issue.fetchFromDatabase(doc)).toList();
  }

  // add report to tower, save to firestore
  Future<void> addReport(Report report) async {
    reports.add(report);
    await FirebaseFirestore.instance.collection('towers').doc(id).collection('reports').doc(report.id).set(report.toMap());
  }

  Future<void> addIssue(Issue issue) async {
    issues.add(issue);
    await FirebaseFirestore.instance.collection('towers').doc(id).collection('issues').doc(issue.id).set(issue.toMap());
  }

  Future<void> removeIssue(Issue issue) async {
    issues.remove(issue);
    await FirebaseFirestore.instance.collection('towers').doc(id).collection('issues').doc(issue.id).delete();
  }

  Future<void> updateIssueStatus(String issueId, String newStatus) async {
    try {
      // Find the issue in the tower's local issues list
      final issue = issues.firstWhere((issue) => issue.id == issueId, orElse: () => throw Exception("Issue not found"));

      // Update the status locally
      issue.status = newStatus;

      // Update the status in Firestore
      await FirebaseFirestore.instance
          .collection('towers')
          .doc(id)
          .collection('issues')
          .doc(issueId)
          .update({'status': newStatus});
          
    } catch (e) {
      print("Error updating issue status in tower: $e");
    }
  }
}