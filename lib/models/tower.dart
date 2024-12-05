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
  List<Report> reports;
  List<Issue> issues;

  // Stream<List<Report>>? reports;
  // Stream<List<Issue>>? issues;

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

    // fetch reports
    final reportsQuery = await FirebaseFirestore.instance
        .collection('towers')
        .doc(doc.id)
        .collection('reports')
        .get();

    // fetch issues
    final issuesQuery = await FirebaseFirestore.instance
        .collection('towers')
        .doc(doc.id)
        .collection('issues')
        .get();

    final List<Report> reports = reportsQuery.docs
        .map((doc) => Report.fromFirestore(doc))
        .toList();

    final List<Issue> issues = issuesQuery.docs
        .map((doc) => Issue.fromFirestore(doc))
        .toList();

    return Tower(
      id: doc.id,
      name: data['name'] as String? ?? 'undefined',
      region: data['region'] as String? ?? 'undefined',
      type: data['type'] as String? ?? 'undefined',
      owner: data['owner'] as String? ?? 'undefined',
      address: data['address'] as String? ?? 'undefined',
      position: data['position'] is GeoPoint
          ? data['position'] as GeoPoint
          : GeoPoint(0, 0),
      status: data['status'] as String? ?? 'undefined',
      notes: data['notes'] as String? ?? 'no notes',
      reports: reports,
      issues: issues,
    );
  }

  // static Tower fromFirestore(DocumentSnapshot doc) {
  //   final data = doc.data()! as Map<String, dynamic>;

  //   // set up report stream
  //   final Stream<List<Report>> reportsStream = FirebaseFirestore.instance
  //       .collection('towers')
  //       .doc(doc.id)
  //       .collection('reports')
  //       .snapshots()
  //       .map((snapshot) =>
  //           snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList());

  //   // set up issue stream
  //   final Stream<List<Issue>> issuesStream = FirebaseFirestore.instance
  //       .collection('towers')
  //       .doc(doc.id)
  //       .collection('issues')
  //       .snapshots()
  //       .map((snapshot) =>
  //           snapshot.docs.map((doc) => Issue.fromFirestore(doc)).toList());

  //   return Tower(
  //     id: doc.id, // Firebase document ID = tower ID
  //     name: data['name'] as String? ?? 'undefined',
  //     region: data['region'] as String? ?? 'undefined',
  //     type: data['type'] as String? ?? 'undefined',
  //     owner: data['owner'] as String? ?? 'undefined',
  //     address: data['address'] as String? ?? 'undefined',
  //     position: data['position'] is GeoPoint
  //         ? data['position'] as GeoPoint
  //         : GeoPoint(0, 0), // fix
  //     status: data['status'] as String? ?? 'undefined',
  //     notes: data['notes'] as String? ?? 'no notes',
  //     reports: reportsStream,
  //     issues: issuesStream,
  //   );
  // }
}
