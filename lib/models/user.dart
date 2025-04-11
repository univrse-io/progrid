import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension UserExtension on User {
  Map<String, dynamic> toJson() => {
    'displayName': displayName,
    'email': email,
    'isEmailVerified': emailVerified,
    'isAnonymous': isAnonymous,
    'creationTime':
        metadata.creationTime != null
            ? Timestamp.fromDate(metadata.creationTime!)
            : null,
    'lastSignInTime':
        metadata.lastSignInTime != null
            ? Timestamp.fromDate(metadata.lastSignInTime!)
            : null,
    'phoneNumber': phoneNumber,
    'photoURL': tenantId,
    'uid': uid,
  };
}
