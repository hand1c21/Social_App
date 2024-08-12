import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return android;
  }

  static FirebaseOptions android = FirebaseOptions(
    apiKey: dotenv.env['API_KEY']!,
    appId: dotenv.env['APP_ID']!,
    projectId: dotenv.env['PROJECT_ID']!,
    messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
    storageBucket: dotenv.env['STORAGE_BUCKET']!,
  );
}