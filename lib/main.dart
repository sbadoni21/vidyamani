import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/screens/splashscreen.dart';
import 'package:vidyamani/services/auth/authentication.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthenticationServices authServices = AuthenticationServices();

  // @override
  // void initState() {
  //   super.initState();
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boarding Admissions',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      // home: HomePage(),

      home: StreamBuilder(
        stream: authServices.firebaseAuth.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }

          if (snapshot.hasError) {
            print("Error with the stream: ${snapshot.error}");
            return const Center(child: Text("An error occurred."));
          }

          if (snapshot.hasData && snapshot.data != null) {
            print("User is authenticated. Navigating to HomePage.");
            return HomePage();
          }

          print("User is not authenticated. Navigating to LoginPage.");

          return LoginPage();
        },
      ),
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
