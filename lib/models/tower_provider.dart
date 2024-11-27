import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];

  // run this to refresh towers list
  Future<void> fetchTowers() async {
    try {
      towers = []; // reset list
      final snapshot = await FirebaseFirestore.instance.collection('towers').get();

      // fetch each tower
      for (final doc in snapshot.docs) {
        final Tower tower = await Tower.fetchFromDatabase(doc);
        towers.add(tower);
      }
      notifyListeners();
    } catch (e) {
      print("Error Fetching Towers: $e");
    }
  }

  // TODO: is this the best implementation? need review
  void updateTower(Tower updatedTower) {
    final index = towers.indexWhere((tower) => tower.id == updatedTower.id);
    if (index != -1) {
      towers[index] = updatedTower;
      notifyListeners();
    }
  }

  // add a report to a tower
  void addReportToTower(String towerId, Report report) {
    final tower = towers.firstWhere((tower) => tower.id == towerId, orElse: () => throw Exception("Tower not found"));
    tower.addReport(report);
    notifyListeners();
  }

  // add an issue to a tower
  Future<void> addIssueToTower(String towerId, Issue issue) async {
    final tower = towers.firstWhere((tower) => tower.id == towerId);
    await tower.addIssue(issue);
    notifyListeners();
  }

  // remove an issue from a tower
  Future<void> removeIssueFromTower(String towerId, Issue issue) async {
    final tower = towers.firstWhere((tower) => tower.id == towerId);
    await tower.removeIssue(issue);
    notifyListeners();
  }
}

// Tower Model
class Tower extends ChangeNotifier {
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
    final snapshot = await FirebaseFirestore.instance
        .collection('towers')
        .doc(towerId)
        .collection('reports')
        .get();
    return snapshot.docs.map((doc) => Report.fetchFromDatabase(doc)).toList();
  }

  // fetch tower issues
  static Future<List<Issue>> fetchIssues(String towerId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('towers')
        .doc(towerId)
        .collection('issues')
        .get();
    return snapshot.docs.map((doc) => Issue.fetchFromDatabase(doc)).toList();
  }

  // add report to tower, save to firestore
  Future<void> addReport(Report report) async {
    reports.add(report);
    await FirebaseFirestore.instance
        .collection('towers')
        .doc(id)
        .collection('reports')
        .doc(report.id)
        .set(report.toMap());
  }

  Future<void> addIssue(Issue issue) async {
    issues.add(issue);
    await FirebaseFirestore.instance
        .collection('towers')
        .doc(id)
        .collection('issues')
        .doc(issue.id)
        .set(issue.toMap());
  }

  Future<void> removeIssue(Issue issue) async {
    issues.remove(issue);
    await FirebaseFirestore.instance
        .collection('towers')
        .doc(id)
        .collection('issues')
        .doc(issue.id)
        .delete();
  }
}

// Report Model
class Report {
  String id;
  Timestamp dateTime;
  String authorId;
  String authorName;
  // List<String> pictures;
  String notes;

  // constructor
  Report({
    this.id = '', // will be filled when created in firestore
    required this.dateTime,
    required this.authorId,
    required this.authorName,
    // this.pictures = const [], // default empty
    this.notes = 'no notes', // default
  });

  // format for database
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'authorId': authorId,
      'authorName': authorName,
      'notes': notes,
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
      // pictures: data['pictures'] != null ? data['pictures'] as List<String> : [],
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

// Issue Model
class Issue {
  String id;
  String status;
  Timestamp dateTime;
  String authorId;
  String authorName;
  String description;
  List<String> tags;

  // constructor
  Issue({
    required this.id,
    required this.status,
    required this.dateTime,
    required this.authorId,
    required this.authorName,
    this.description = 'no description',
    this.tags = const [],
  });

  // format for database
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'dateTime': dateTime,
      'authorId': authorId,
      'authorName': authorName,
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
      authorName: data['authorName'] as String,
      description: data['description'] as String? ?? 'no description',
      tags: data['tags'] != null ? List<String>.from(data['tags'] as List<dynamic>) : [],
    );
  }

  // update issue details
  Future<void> updateDetails(String towerId) async {
    await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('issues').doc(id).update(toMap());
  }
}
