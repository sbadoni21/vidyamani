import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:vidyamani/notifier/user_state_notifier.dart';
import 'package:vidyamani/screens/home_page.dart';
import 'package:vidyamani/screens/loginscreen.dart';
import 'package:vidyamani/utils/static.dart';
class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(
      userStateNotifierProvider,
    );
    return SafeArea(
        child: AnimatedSplashScreen(
      animationDuration: const Duration(seconds: 2),
      duration: 3000,
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
      nextScreen: userState == null ? LoginPage() : HomePage(),
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      backgroundColor: bgColor,
    ));
  }
}