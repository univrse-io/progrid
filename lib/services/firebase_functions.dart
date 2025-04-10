import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctionsService {
  final _region = 'asia-southeast1';

  Future<void> grantAdminRole({required String email}) async {
    try {
      final result = await FirebaseFunctions.instanceFor(region: _region)
          .httpsCallable('grantAdminRole')
          .call({'email': email});
      final data = result.data as Map<String, dynamic>;
      final message = data['message'] as String;

      log(message);
    } on FirebaseFunctionsException catch (e) {
      log('Failed to grant admin role.', error: e);
      rethrow;
    }
  }

  Future<void> revokeAdminRole({required String email}) async {
    try {
      final result = await FirebaseFunctions.instanceFor(region: _region)
          .httpsCallable('revokeAdminRole')
          .call({'email': email});
      final data = result.data as Map<String, dynamic>;
      final message = data['message'] as String;

      log(message);
    } on FirebaseFunctionsException catch (e) {
      log('Failed to revoke admin role.', error: e);
      rethrow;
    }
  }
}
