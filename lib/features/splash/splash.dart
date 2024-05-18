import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medical_corner/features/home/home.dart';
import 'package:page_transition/page_transition.dart';
import '../introduction/introduction.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/lottie_animations/splash.json'),
      backgroundColor: Colors.lightBlue,
      nextScreen: FirebaseAuth.instance.currentUser == null
          ? const IntroductionPage()
          : FirebaseAuth.instance.currentUser!.emailVerified == true
              ? const Homepage()
              : const IntroductionPage(),
      splashIconSize: 300,
      duration: 2000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: const Duration(seconds: 1),
    );
  }
}
