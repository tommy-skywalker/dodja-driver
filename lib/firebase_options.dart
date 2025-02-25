import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhK8l1MFQDzgXAB0p8YY9XLuUmPl_T8SI',
    appId: '1:752138386776:android:e5d748e19e9627eb72792d',
    messagingSenderId: '752138386776',
    projectId: 'custom-dodja-errand',
    storageBucket: 'custom-dodja-errand.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOFm-o6kwFZKcGIbu3gvV28mLvKcb34-Y',
    appId: '1:752138386776:ios:d93a12bcc6d691ca72792d',
    messagingSenderId: '752138386776',
    projectId: 'custom-dodja-errand',
    storageBucket: 'custom-dodja-errand.firebasestorage.app',
    iosClientId: '752138386776-k0di117iej3mmnd0bar3mv901jmts9r1.apps.googleusercontent.com',
    iosBundleId: 'com.dodjaerrands.dodjaerrandsdriver',
  );

}