import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vidyamani/screens/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBEiWRAVIwyxYZ6cgqoVizmLOMLCAopUh8",
            authDomain: "vidyamani-94f4a.firebaseapp.com",
            projectId: "vidyamani-94f4a",
            storageBucket: "vidyamani-94f4a.appspot.com",
            messagingSenderId: "862420344316",
            appId: "1:862420344316:web:3086d929b0f710d2bbe679",
            measurementId: "G-ZC1VKV8DHC"));
    logger.i("Firebase initialized successfully");
    runApp(MyApp());
  } catch (e) {
    logger.e(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashScreen());
  }
}
