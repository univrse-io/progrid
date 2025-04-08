import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

class FirebaseFunctionsService {
  Future<void> grantAdminRole({required String email}) async {
    try {
      final result = await FirebaseFunctions.instanceFor(
        region: 'asia-southeast1',
      ).httpsCallable('grantAdminRole').call({'email': email});

      log(result.data.toString());
    } on FirebaseFunctionsException catch (e) {
      log('Failed to grant admin role.', error: e);
      rethrow;
    }
  }
}
