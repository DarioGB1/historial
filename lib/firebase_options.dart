// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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
    apiKey: 'AIzaSyBGmHIjNEGwUXQMuBLxCLKhCjNRRNLouhs',
    appId: '1:788245975395:web:78bcf4eec818be57d5c356',
    messagingSenderId: '788245975395',
    projectId: 'historialmedico-13cc2',
    authDomain: 'historialmedico-13cc2.firebaseapp.com',
    storageBucket: 'historialmedico-13cc2.firebasestorage.app',
    measurementId: 'G-R886LEYGR8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA8xV-6zXD4rwQDzHXf5FzEPKSooDwY-ks',
    appId: '1:788245975395:android:b3ae2a0368fdc883d5c356',
    messagingSenderId: '788245975395',
    projectId: 'historialmedico-13cc2',
    storageBucket: 'historialmedico-13cc2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDuhjQ3bMUbcjJAIOTYsAp9mwNfU87lPfM',
    appId: '1:788245975395:ios:5a90bc62bc3e9de9d5c356',
    messagingSenderId: '788245975395',
    projectId: 'historialmedico-13cc2',
    storageBucket: 'historialmedico-13cc2.firebasestorage.app',
    iosBundleId: 'com.example.historialmedico',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDuhjQ3bMUbcjJAIOTYsAp9mwNfU87lPfM',
    appId: '1:788245975395:ios:5a90bc62bc3e9de9d5c356',
    messagingSenderId: '788245975395',
    projectId: 'historialmedico-13cc2',
    storageBucket: 'historialmedico-13cc2.firebasestorage.app',
    iosBundleId: 'com.example.historialmedico',
  );
}
