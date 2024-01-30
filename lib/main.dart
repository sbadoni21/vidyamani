import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:flutter/services.dart';
import 'package:vidyamani/screens/splashscreen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final logger = Logger(
    printer: PrettyPrinter(),
  );
  try {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyBxCBrAlZ6halzhijHTqXZIpdGSqaH8Ngs",
            authDomain: "vidhyamani-fc424.firebaseapp.com",
            databaseURL: "https://vidhyamani-fc424-default-rtdb.firebaseio.com",
            projectId: "vidhyamani-fc424",
            storageBucket: "vidhyamani-fc424.appspot.com",
            messagingSenderId: "130812012525",
            appId: "1:130812012525:web:8ae372f77f6b9a433369e4",
            measurementId: "G-V2WCRHMKV6")
            );
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
