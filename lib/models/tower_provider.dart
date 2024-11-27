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

  Future<void> addIssueToTower(String towerId, Issue issue) async {
    final tower = towers.firstWhere((tower) => tower.id == towerId);
    await tower.addIssue(issue);
    notifyListeners();
  }

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

  // TODO: implement ticket objects (inspection and issues)
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

  // update status, save to database
  Future<void> updateStatus(String status) async {
    this.status = status;
    await FirebaseFirestore.instance.collection('towers').doc(id).update({
      'status': status,
    });
  }

  // add an issue, save to database
  Future<void> addIssue(Issue issue) async {
    issues.add(issue);
    await FirebaseFirestore.instance.collection('towers').doc(id).collection('issues').doc(issue.id).set(issue.toMap());
    TowersProvider().notifyListeners();
  }

  // remove issue, save to database
  Future<void> removeIssue(Issue issue) async {
    issues.remove(issue);
    await FirebaseFirestore.instance.collection('towers').doc(id).collection('issues').doc(issue.id).delete();
    TowersProvider().notifyListeners();
  }

  // given a tower document, fetch from database
  static Future<Tower> fetchFromDatabase(DocumentSnapshot doc) async {
    final data = doc.data()! as Map<String, dynamic>;

    // fetch reports
    final List<Report> reports = [];
    final List<Issue> issues = [];
    final reportSnapshot = await FirebaseFirestore.instance.collection('towers').doc(doc.id).collection('reports').get();
    final issueSnapshot = await FirebaseFirestore.instance.collection('towers').doc(doc.id).collection('issues').get();

    for (final reportDoc in reportSnapshot.docs) {
      final report = Report.fetchFromDatabase(reportDoc);
      reports.add(report);
    }

    for (final issueDoc in issueSnapshot.docs) {
      final issue = Issue.fetchFromDatabase(issueDoc);
      issues.add(issue);
    }

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
}

// Report Model
class Report {
  String id;
  Timestamp dateTime;
  String authorId;
  // List<String> pictures;
  String notes;

  // constructor
  Report({
    this.id = '', // will be filled when created in firestore
    required this.dateTime,
    required this.authorId,
    // this.pictures = const [], // default empty
    this.notes = 'no notes', // default
  });

  // format for database
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'authorId': authorId,
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
      // pictures: data['pictures'] != null ? data['pictures'] as List<String> : [],
      notes: data['notes'] as String? ?? 'no notes',
    );
  }

  // save report to firestore given tower id
  Future<void> saveToDatabase(String towerId) async {
    try {
      final reference = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('reports').add({
        'dateTime': dateTime,
        'authorId': authorId,
        'notes': notes,
      });

      id = reference.id; // unique ID, replace?
    } catch (e) {
      print("Error saving report: $e");
    }
  }
}

// Issue Model
class Issue {
  String id;
  String status;
  Timestamp dateTime;
  String authorId;
  String description;
  List<String> tags;

  // constructor
  Issue({
    required this.id,
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
}
