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
            apiKey: "AIzaSyBEiWRAVIwyxYZ6cgqoVizmLOMLCAopUh8",
            authDomain: "vidyamani-94f4a.firebaseapp.com",
            projectId: "vidyamani-94f4a",
            storageBucket: "vidyamani-94f4a.appspot.com",
            messagingSenderId: "862420344316",
            appId: "1:862420344316:web:3086d929b0f710d2bbe679",
            measurementId: "G-ZC1VKV8DHC"));
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
