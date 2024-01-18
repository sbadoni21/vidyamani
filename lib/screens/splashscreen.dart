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
      animationDuration: const Duration(seconds: 2),
      duration: 3000,
      // splash: (
      //   children: [

      //     // const Text(
      //     //   "Vidhyamani",
      //     //   style: TextStyle(
      //     //     color: Colors.white,
      //     //     fontSize: 24,
      //     //     fontWeight: FontWeight.w600,
      //     //   ),
      //     // )
      //   ]
      // ),
      splash: ListView(
        children: [
          Image.asset(
            "lib/assets/images/logowhite.png",
            height: 270,
            width: 270,
          ),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: const Text(
              "Vidhyamani",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      splashIconSize: 350,
      centered: true,

      nextScreen: LoginPage(),
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      backgroundColor: bgColor,
    ));
  }
}
