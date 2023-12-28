import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vidyamani/utils/static.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: AnimatedSplashScreen(
      duration: 3000,
      splash: Column(children: [
        Image.asset("lib/assets/images/logowhite.png"),
        Text(
          "Vidhyamani",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        )
      ]),
      nextScreen: LoginPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      backgroundColor: bgColor,
    ));
  }
}
