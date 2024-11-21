import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progrid/models/inspection_ticket.dart';
import 'package:progrid/models/issue_ticket.dart';

class Tower {
  String towerId;
  String siteId;
  String address;
  String status;
  String notes;

  List<InspectionTicket> inspections;
  List<IssueTicket> issues;

  Tower({
    required this.towerId,
    required this.siteId,
    required this.address,
    required this.status,
    required this.notes,
    this.inspections = const [],
    this.issues = const [],
  });

  // fetch a tower from database
  factory Tower.fromDatabase(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Tower(
      towerId: doc.id,
      siteId: data['siteId'] ?? '',
      address: data['address'] ?? '',
      status: data['status'] ?? '',
      notes: data['notes'] ?? '',
    );
  }

  // fetch associated tickets (both inspections and issues)
  Future<void> fetchTickets() async {
    try {
      final inspectionsSnapshot = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('inspections').get();
      final issuesSnapshot = await FirebaseFirestore.instance.collection('towers').doc(towerId).collection('issues').get();

      inspections = inspectionsSnapshot.docs.map((doc) => InspectionTicket.fromMap(doc.data())).toList();
      issues = issuesSnapshot.docs.map((doc) => IssueTicket.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching tickets for tower $towerId: $e");
    }
  }
}

// a singleton app-wide class that holds list of towers
class TowerService {
  static final TowerService _instance = TowerService._internal();
  List<Tower> towers = [];

  factory TowerService() {
    return _instance;
  }

  TowerService._internal();

  // should be run on app start, or a page refresh
  Future<void> fetchTowers() async {
    try {
      towers = [];
      final snapshot = await FirebaseFirestore.instance.collection('towers').get();

      // fetch each tower and its associated tickets
      for (var doc in snapshot.docs) {
        Tower tower = Tower.fromDatabase(doc);
        await tower.fetchTickets();
        towers.add(tower);
      }
    } catch (e) {
      print("Error fetching towers: $e");
    }
  }

  List<Tower> getTowers() {
    return towers;
  }
}
