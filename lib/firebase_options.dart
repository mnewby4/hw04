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
    apiKey: 'AIzaSyDz2XLvA89BGP0nGDEuYiwzlNNeeY2uGoc',
    appId: '1:383056640879:web:e0efa4d80de851b955c69a',
    messagingSenderId: '383056640879',
    projectId: 'hw04-29e05',
    authDomain: 'hw04-29e05.firebaseapp.com',
    storageBucket: 'hw04-29e05.firebasestorage.app',
    measurementId: 'G-JPWGX14V4M',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAZa3aQVTd9cx4Qr0yQLhh_15kC9f1w36M',
    appId: '1:383056640879:android:37480662ab974ee855c69a',
    messagingSenderId: '383056640879',
    projectId: 'hw04-29e05',
    storageBucket: 'hw04-29e05.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDz2XLvA89BGP0nGDEuYiwzlNNeeY2uGoc',
    appId: '1:383056640879:web:09ae2d918fc02c3155c69a',
    messagingSenderId: '383056640879',
    projectId: 'hw04-29e05',
    authDomain: 'hw04-29e05.firebaseapp.com',
    storageBucket: 'hw04-29e05.firebasestorage.app',
    measurementId: 'G-QS2Y7T46G5',
  );
}
