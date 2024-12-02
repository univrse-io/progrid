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
  static Future<Tower> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data()! as Map<String, dynamic>;

    // fetch reports and issues
    final List<Report> reports = await _fetchReports(doc.id);
    final List<Issue> issues = await _fetchIssues(doc.id);

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
  static Future<List<Report>> _fetchReports(String towerId) async {
    final snapshot = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('reports').get();
    return snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList();
  }

  // fetch tower issues
  static Future<List<Issue>> _fetchIssues(String towerId) async {
    final snapshot = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('issues').get();
    return snapshot.docs.map((doc) => Issue.fromFirestore(doc)).toList();
  }

  // add report to tower, save to firestore
  Future<void> addReport(Report report) async {
    reports.add(report);

    // create report in firebase
    await FirebaseFirestore.instance.collection('towers').doc(id).collection('reports').add(report.toMap());
    // update tower status to 'surveyed'
    await FirebaseFirestore.instance.collection('towers').doc(id).update({'status': 'surveyed'});
  }

  Future<void> addIssue(Issue issue) async {
    issues.add(issue);
    // create issue in firebase
    await FirebaseFirestore.instance.collection('towers').doc(id).collection('issues').add(issue.toMap());
  }

  Future<void> updateIssueStatus(String issueId, String status) async {
    try {
      // find issue locally
      final issue = issues.firstWhere((issue) => issue.id == issueId, orElse: () => throw Exception("Issue not found"));
      
      // update status locally
      issue.status = status;
      // , and in the database as well
      await FirebaseFirestore.instance.collection('towers').doc(id).collection('issues').doc(issueId).update({'status': status});
    } catch (e) {
      print("Error updating issue status in tower: $e");
    }
  }
}
