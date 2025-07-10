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
    apiKey: 'AIzaSyB0JKTa2aAoaWS5r1xW4n03TXXVa3ffl08',
    appId: '1:327212509966:web:4e011ce3967b4778a9855f',
    messagingSenderId: '327212509966',
    projectId: 'spin-to-earn-992fa',
    authDomain: 'spin-to-earn-992fa.firebaseapp.com',
    storageBucket: 'spin-to-earn-992fa.firebasestorage.app',
    measurementId: 'G-2C1ET3BQQZ',
  );

  // Replace these values with your Firebase project configuration

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjfObGGu1OBwCdM8keYdNV1yIopRGcHTs',
    appId: '1:327212509966:android:1c3750a6cc3cd597a9855f',
    messagingSenderId: '327212509966',
    projectId: 'spin-to-earn-992fa',
    storageBucket: 'spin-to-earn-992fa.firebasestorage.app',
  );

  // Add Android configuration if needed

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4uD6Wrf4vjZ1xnpF6LUfPbL-9K81-Cg4',
    appId: '1:327212509966:ios:75f29ecd0853778ca9855f',
    messagingSenderId: '327212509966',
    projectId: 'spin-to-earn-992fa',
    storageBucket: 'spin-to-earn-992fa.firebasestorage.app',
    iosClientId: '327212509966-e0ohe18bv3338t6ctlj34gsdouofqv2j.apps.googleusercontent.com',
    iosBundleId: 'com.example.spinEarning',
  );

  // Add iOS configuration if needed

  // Add macOS configuration if needed
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'your-macos-api-key',
    appId: 'your-macos-app-id',
    messagingSenderId: 'your-messaging-sender-id',
    projectId: 'your-project-id',
    storageBucket: 'your-project-id.appspot.com',
    iosBundleId: 'com.example.yourapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB0JKTa2aAoaWS5r1xW4n03TXXVa3ffl08',
    appId: '1:327212509966:web:643d633a5da457e7a9855f',
    messagingSenderId: '327212509966',
    projectId: 'spin-to-earn-992fa',
    authDomain: 'spin-to-earn-992fa.firebaseapp.com',
    storageBucket: 'spin-to-earn-992fa.firebasestorage.app',
    measurementId: 'G-Y60MD8EQTW',
  );

}