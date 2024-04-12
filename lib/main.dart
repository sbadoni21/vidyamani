import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/splashscreen.dart';
import 'dart:io';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  try {
    Platform.isAndroid ?
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBI9nEVr5mynmnYU5_baSWhZJYKIxZzv-M",
            authDomain: "vidhyamanifinal.firebaseapp.com",
            projectId: "vidhyamanifinal",
            storageBucket: "vidhyamanifinal.appspot.com",
            messagingSenderId: "706411405865",
            appId: "1:706411405865:web:443bfe93d25a5a14fb3238",
            measurementId: "G-CTJ8HVF80L")
    ) :
        await Firebase.initializeApp();
    logger.i("Firebase initialized successfully");
    MobileAds.instance.initialize();
    runApp(ProviderScope(child: MyApp()));
  } catch (e) {
    logger.e("Firebase initialization error: $e");
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(
      userStateNotifierProvider,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vidyamani',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: navigatorKey,
      home: userState == null ? SplashScreen() : HomePage(),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String errorMessage;
  ErrorApp(this.errorMessage);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Error',
      home: Scaffold(
        body: Center(
          child: Text(errorMessage),
        ),
      ),
    );
  }
}
