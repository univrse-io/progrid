import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
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
    apiKey: 'AIzaSyCNSR2YpGI8NQI1OssC5g8WsWAWXv0H4a0',
    appId: '1:190251764983:web:697f5c1a794f495bdc57f2',
    messagingSenderId: '190251764983',
    projectId: 'sapura-580e1',
    authDomain: 'sapura-580e1.firebaseapp.com',
    storageBucket: 'sapura-580e1.firebasestorage.app',
    measurementId: 'G-1T4NQCPFF9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD9eRmRwCLBrW_2ZguWziaH_syiXdjnV6Y',
    appId: '1:190251764983:android:ee442f199b3726d6dc57f2',
    messagingSenderId: '190251764983',
    projectId: 'sapura-580e1',
    storageBucket: 'sapura-580e1.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDjkO30vucz0ntdlIvU0FZc9Z03kV5OKU',
    appId: '1:190251764983:ios:9d9c3412aaa7f448dc57f2',
    messagingSenderId: '190251764983',
    projectId: 'sapura-580e1',
    storageBucket: 'sapura-580e1.firebasestorage.app',
    iosBundleId: 'com.univrse.progrid',
  );
}
