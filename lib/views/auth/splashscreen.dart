import 'package:barber/data/local/shared_preferences.dart';
import 'package:barber/extensions/extensions.dart';
import 'package:barber/views/auth/onboarding_page.dart';
import 'package:barber/widget/botnav.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLogin();
    });
  }

  void checkLogin() async {
    final isLogin = await PreferenceHandler.getLogin();
    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (!mounted) return;

      if (isLogin == true) {
        context.pushReplacementNamed(Botbar.id);
      } else {
        context.pushNamed(OnboardingPage.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset("assets/lotiie/animation.json", fit: BoxFit.fill);
    // Scaffold(
    // backgroundColor: AppColors.offWhite,
    // body:
    // Center(
    //   child: Lottie.asset("assets/lotiie/animation.json"),
    //   // child: Image.asset(AppImage.logo, width: 275, fit: BoxFit.cover),
    // ),
    // );
  }
}
