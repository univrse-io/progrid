import 'package:cloud_firestore/cloud_firestore.dart';

class InspectionTicket {
  String ticketId;
  String userId; // owner

  Timestamp dateTime;
  String status;
  List<String> photos; // array of urls
  String notes;

  InspectionTicket({
    required this.ticketId,
    required this.userId,
    required this.dateTime,
    required this.status,
    this.photos = const [],
    this.notes = '',
  });

  // create new instance
  factory InspectionTicket.create({
    required String ticketId,
    required String userId,
    required Timestamp dateTime,
    required String status,
    List<String> photos = const [],
    String notes = '',
  }) {
    return InspectionTicket(
      ticketId: ticketId,
      userId: userId,
      dateTime: dateTime,
      status: status,
      photos: photos,
      notes: notes,
    );
  }

  // grab from database directly
  factory InspectionTicket.fromMap(Map<String, dynamic> data) {
    return InspectionTicket(
      ticketId: data['ticketId'] ?? '',
      userId: data['userId'] ?? '',
      dateTime: data['dateTime'] ?? Timestamp.now(),
      status: data['status'] ?? 'open',
      photos: List<String>.from(data['photos'] ?? []),
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'dateTime': dateTime,
      'status': status,
      'photos': photos,
      'notes': notes,
    };
  }

  @override
  String toString() {
    return 'InspectionTicket{ticketId: $ticketId, userId: $userId, dateTime: $dateTime, status: $status, photos: $photos, notes: $notes}';
  }
}