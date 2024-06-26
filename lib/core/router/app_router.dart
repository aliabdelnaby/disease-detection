import 'package:flutter/material.dart';
import 'package:medical_corner/features/classification/kidney/kidney.dart';

import '../../features/classification/brain%20tumour/brain_tumour.dart';
import '../../features/classification/pneumonia/pneumonia_screen.dart';
import '../../features/home/home.dart';
import '../../features/auth/auth_sheet/sign_up.dart';
import '../../features/introduction/introduction.dart';
import '../../features/nvdrawer/aboutus.dart';
import '../../features/nvdrawer/contactus.dart';
import '../../features/nvdrawer/profile.dart';
import '../../features/prediction/diabetes/diabetes_screen.dart';
import '../../features/prediction/heart/views/heart_screen.dart';
import '../../features/splash/splash.dart';
import '../const/screens_names.dart';
import 'custom_page_route.dart';

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
      case kidney:
        return CustomPageRoute(
            direction: AxisDirection.left, child: const KidneyScreen());
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
