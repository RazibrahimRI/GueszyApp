import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      // Web Firebase config
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDOFrAYJd5Ruq3QitQSs_VRqon_W2MhkuU",
          authDomain: "hangmenn-4d2b7.firebaseapp.com",
          projectId: "hangmenn-4d2b7",
          storageBucket: "hangmenn-4d2b7.firebasestorage.app",
          messagingSenderId: "662059762100",
          appId: "1:662059762100:web:dbe240e38371bbb748b2e1",
          measurementId: "G-Q6YB4QXPKP",
        ),
      );
    } else {
      // Mobile Firebase config (auto-detected)
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(HangmanApp());
}

class HangmanApp extends StatelessWidget {
  const HangmanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangman OpenAI',
      theme: ThemeData.light(),
      home:  IntroPage(),
    );
  }
}

