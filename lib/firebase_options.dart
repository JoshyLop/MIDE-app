import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
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
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCLJCAtx5GB_2zUz7r6EMpzgdOAbAkHSlg',
    appId: '1:950425569660:web:9a82d1b4946e064ca7fcf9',
    messagingSenderId: '950425569660',
    projectId: 'mide-app-issste',
    storageBucket: 'mide-app-issste.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLJCAtx5GB_2zUz7r6EMpzgdOAbAkHSlg',
    appId: '1:950425569660:android:9a82d1b4946e064ca7fcf9',
    messagingSenderId: '950425569660',
    projectId: 'mide-app-issste',
    storageBucket: 'mide-app-issste.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLJCAtx5GB_2zUz7r6EMpzgdOAbAkHSlg',
    appId: '1:950425569660:ios:9a82d1b4946e064ca7fcf9',
    messagingSenderId: '950425569660',
    projectId: 'mide-app-issste',
    storageBucket: 'mide-app-issste.firebasestorage.app',
    iosBundleId: 'com.example.mideApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCLJCAtx5GB_2zUz7r6EMpzgdOAbAkHSlg',
    appId: '1:950425569660:ios:9a82d1b4946e064ca7fcf9',
    messagingSenderId: '950425569660',
    projectId: 'mide-app-issste',
    storageBucket: 'mide-app-issste.firebasestorage.app',
    iosBundleId: 'com.example.mideApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCLJCAtx5GB_2zUz7r6EMpzgdOAbAkHSlg',
    appId: '1:950425569660:windows:9a82d1b4946e064ca7fcf9',
    messagingSenderId: '950425569660',
    projectId: 'mide-app-issste',
    storageBucket: 'mide-app-issste.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyCLJCAtx5GB_2zUz7r6EMpzgdOAbAkHSlg',
    appId: '1:950425569660:linux:9a82d1b4946e064ca7fcf9',
    messagingSenderId: '950425569660',
    projectId: 'mide-app-issste',
    storageBucket: 'mide-app-issste.firebasestorage.app',
  );
}
