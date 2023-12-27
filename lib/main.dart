import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAA6conKiTEoYcpXEu5Q2Zh5QwZSxkPtWc",
          authDomain: "notifymeapp-e884b.firebaseapp.com",
          projectId: "notifymeapp-e884b",
          storageBucket: "notifymeapp-e884b.appspot.com",
          messagingSenderId: "681497384601",
          appId: "1:681497384601:web:2270449befedf5f9abca08"),
    );
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
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}