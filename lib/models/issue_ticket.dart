import 'package:cloud_firestore/cloud_firestore.dart';

class IssueTicket {
  String ticketId;
  String userId; // owner

  Timestamp dateTime;
  String status;
  
  List<String> photos; // array of urls
  List<String> tags; // standard strings
  String notes;

  IssueTicket({
    required this.ticketId,
    required this.userId,
    required this.dateTime,
    required this.status,
    this.photos = const [],
    this.tags = const [],
    this.notes = '',
  });

  // create new instance
  factory IssueTicket.create({
    required String ticketId,
    required String userId,
    required Timestamp dateTime,
    required String status,
    List<String> photos = const [],
    List<String> tags = const [],
    String notes = '',
  }) {
    return IssueTicket(
      ticketId: ticketId,
      userId: userId,
      dateTime: dateTime,
      status: status,
      photos: photos,
      tags: tags,
      notes: notes,
    );
  }

  // grab from database directly
  factory IssueTicket.fromMap(Map<String, dynamic> data) {
    return IssueTicket(
      ticketId: data['ticketId'] ?? '',
      userId: data['userId'] ?? '',
      dateTime: data['dateTime'] ?? Timestamp.now(),
      status: data['status'] ?? 'open',
      photos: List<String>.from(data['photos'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'dateTime': dateTime,
      'status': status,
      'photos': photos,
      'tags': tags,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'IssueTicket{ticketId: $ticketId, userId: $userId, dateTime: $dateTime, status: $status, photos: $photos, tags: $tags, notes: $notes}';
  }
}
