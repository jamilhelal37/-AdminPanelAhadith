

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;











class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDMNJACeAbZz1tgdjNkwC7e4Yx3ttMKujI',
    appId: '1:534126608855:web:b99eec5e247f9c52608b92',
    messagingSenderId: '534126608855',
    projectId: 'ahadith-b577f',
    authDomain: 'ahadith-b577f.firebaseapp.com',
    storageBucket: 'ahadith-b577f.firebasestorage.app',
    measurementId: 'G-M2MN5HH8QM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCe8J0HlUVdFWnDnwYDEeYMbGGhmwQSMX8',
    appId: '1:534126608855:android:2b5235bd9e27632c608b92',
    messagingSenderId: '534126608855',
    projectId: 'ahadith-b577f',
    storageBucket: 'ahadith-b577f.firebasestorage.app',
  );
}
