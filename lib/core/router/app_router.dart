import 'package:flutter/material.dart';
import 'package:medical_corner/core/const/screens_names.dart';
import 'package:medical_corner/core/router/custom_page_route.dart';
import 'package:medical_corner/features/classification/brain%20tumour/brain_tumour.dart';
import 'package:medical_corner/features/classification/pneumonia/pneumonia_screen.dart';
import 'package:medical_corner/features/nvdrawer/contactus.dart';
import 'package:medical_corner/features/nvdrawer/aboutus.dart';
import 'package:medical_corner/features/nvdrawer/profile.dart';
import 'package:medical_corner/features/prediction/diabetes_screen.dart';
import 'package:medical_corner/features/prediction/heart_screen.dart';
import 'package:medical_corner/features/home.dart';
import 'package:medical_corner/features/introduction/auth_sheet/sign_up.dart';
import 'package:medical_corner/features/introduction/introduction.dart';
import 'package:medical_corner/features/splash.dart';

class AppRouter {
  late Widget startScreen;

  Route? onGenerateRoute(RouteSettings settings) {
    startScreen = const SplashScreen();

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => startScreen);
      case homepage:
        return CustomPageRoute(
            direction: AxisDirection.left, child: const Homepage());
      case signup:
        return CustomPageRoute(
            direction: AxisDirection.left, child: const SignUp());
      case introductionPage:
        return MaterialPageRoute(builder: (_) => const IntroductionPage());
      case pneumoniaScreen:
        return CustomPageRoute(
            direction: AxisDirection.left, child: const PneumoniaScreen());
      case brainScreen:
        return CustomPageRoute(
            direction: AxisDirection.left, child: const BrainScreen());
      case diabetesScreen:
        return CustomPageRoute(
            direction: AxisDirection.left, child: const DiabetesScreen());
      case heartDisease:
        return CustomPageRoute(
            direction: AxisDirection.left, child: const HeartDisease());
      case profile:
        return CustomPageRoute(
            direction: AxisDirection.right, child: const Profile());
      case aboutus:
        return CustomPageRoute(
            direction: AxisDirection.right, child: const Aboutus());
      case contactus:
        return CustomPageRoute(
            direction: AxisDirection.right, child: const Contactus());
      default:
        return null;
    }
  }
}
