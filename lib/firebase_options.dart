import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

sealed class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS ||
          TargetPlatform.windows ||
          TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ${defaultTargetPlatform.name} - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCkuxwkJcZIzowyQxzMCIP1LtaiYrThjIo',
    appId: '1:678276190882:web:32ed345fbe02137edebdfb',
    messagingSenderId: '678276190882',
    projectId: 'progrid-3a41b',
    authDomain: 'progrid-3a41b.firebaseapp.com',
    storageBucket: 'progrid-3a41b.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuN1qOw580nUATHVsgLQRcU2ncEFuXFIg',
    appId: '1:678276190882:android:88cbd603453477b3debdfb',
    messagingSenderId: '678276190882',
    projectId: 'progrid-3a41b',
    storageBucket: 'progrid-3a41b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA1AZOFgjEzXXtUI3yXGNaPIKFaq1W4BTQ',
    appId: '1:678276190882:ios:8e56ec152d7297afdebdfb',
    messagingSenderId: '678276190882',
    projectId: 'progrid-3a41b',
    storageBucket: 'progrid-3a41b.firebasestorage.app',
    iosBundleId: 'com.univrse.progrid',
  );
}
