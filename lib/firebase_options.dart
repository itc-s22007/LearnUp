// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/cupertino.dart';
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
        return windows;
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
    apiKey: 'AIzaSyAaSP8CDu7bYMXtquWvDq6RVESZ_vBJ6uw',
    appId: '1:987837893217:web:c744223ce08e233063b820',
    messagingSenderId: '987837893217',
    projectId: 'learnup-82610',
    authDomain: 'learnup-82610.firebaseapp.com',
    storageBucket: 'learnup-82610.firebasestorage.app',
    measurementId: 'G-JJ6TMHTERT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDumutuP9wbRzqyT1eNYvqw-2ai9ivi9y0',
    appId: '1:987837893217:android:e1aa289a4e1adab863b820',
    messagingSenderId: '987837893217',
    projectId: 'learnup-82610',
    storageBucket: 'learnup-82610.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAEFuLhmZ8LDIwg_UifZaBuY-RMuy-rCf0',
    appId: '1:987837893217:ios:31e40074896c8a6463b820',
    messagingSenderId: '987837893217',
    projectId: 'learnup-82610',
    storageBucket: 'learnup-82610.firebasestorage.app',
    iosBundleId: 'com.example.learnup',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAEFuLhmZ8LDIwg_UifZaBuY-RMuy-rCf0',
    appId: '1:987837893217:ios:31e40074896c8a6463b820',
    messagingSenderId: '987837893217',
    projectId: 'learnup-82610',
    storageBucket: 'learnup-82610.firebasestorage.app',
    iosBundleId: 'com.example.learnup',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAaSP8CDu7bYMXtquWvDq6RVESZ_vBJ6uw',
    appId: '1:987837893217:web:da8ca63d5b665ae863b820',
    messagingSenderId: '987837893217',
    projectId: 'learnup-82610',
    authDomain: 'learnup-82610.firebaseapp.com',
    storageBucket: 'learnup-82610.firebasestorage.app',
    measurementId: 'G-T864NRGX9B',
  );

}