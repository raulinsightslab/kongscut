import 'package:barber/extensions/extensions.dart';
import 'package:barber/utils/utils.dart';
import 'package:barber/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(const KongCutsApp());
}

class KongCutsApp extends StatelessWidget {
  const KongCutsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentPage = 0;
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Column(
        children: [
          /// === PAGEVIEW ===
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  currentPage = index;
                  onLastPage = (index == 2);
                });
              },
              children: [
                /// PAGE 1
                Container(
                  color: AppColors.offWhite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 50),
                      Image.asset(
                        "assets/images/logo_kongcuts_fix.png",
                        height: 320,
                      ),
                      SizedBox(height: 16),
                      const Text(
                        "WELCOME TO KONGCUTS!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your Ultimate Grooming Experience.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                      Image.asset(
                        "assets/images/kartu_landing_fix.png",
                        height: 260,
                      ),
                    ],
                  ),
                ),

                /// PAGE 2
                Container(
                  color: AppColors.offWhite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Professional Barber",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Nikmati layanan barber profesional "
                        "dengan gaya modern dan stylish.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                /// PAGE 3
                Container(
                  color: AppColors.offWhite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Best Grooming Tools",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Kami hanya menggunakan peralatan terbaik "
                        "untuk hasil maksimal.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: AppColors.offWhite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Professional Barber",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Nikmati layanan barber profesional "
                        "dengan gaya modern dan stylish.",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// === NAVIGATION BAR ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// PREV
                TextButton(
                  onPressed: currentPage == 0
                      ? null
                      : () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                  child: Text(
                    "Prev",
                    style: TextStyle(
                      fontSize: 18,
                      color: currentPage == 0
                          ? AppColors.grey
                          : AppColors.darkRed,
                    ),
                  ),
                ),

                /// INDICATOR
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.black,
                  ),
                ),

                /// NEXT / GET STARTED
                TextButton(
                  onPressed: () {
                    if (onLastPage) {
                      context.push(LoginPage());
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    onLastPage ? "Started" : "Next",
                    style: TextStyle(
                      color: AppColors.darkRed,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _socialButton(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(assetPath, height: 28, width: 28),
    );
  }
}
