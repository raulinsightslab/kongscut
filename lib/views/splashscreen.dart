import 'package:barber/extensions/extensions.dart';
import 'package:barber/services/local/shared_preferences.dart';
import 'package:barber/utils/utils.dart';
import 'package:barber/views/dashboard.dart';
import 'package:barber/views/onboarding_page.dart';
import 'package:flutter/material.dart';

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
        context.pushReplacementNamed(DashboardPage.id);
      } else {
        context.pushNamed(OnboardingPage.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Center(
        // child: Image.asset(AppImage.logo, width: 275, fit: BoxFit.cover),
      ),
    );
  }
}
