import 'package:barber/data/api/service_api.dart';
import 'package:barber/data/local/shared_preferences.dart';
import 'package:barber/extensions/extensions.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:barber/utils/utils.dart';
import 'package:barber/views/auth/onboarding_page.dart';
import 'package:barber/views/detail_services_page.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});
  static const id = "/dashboard";

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final int _currentIndex = 0; // jangan pakai final biar bisa diubah
  late Future<GetServices> futureService;

  @override
  void initState() {
    super.initState();
    futureService = AuthenticationAPIServices.getService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Our Services",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkRed,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Categories dari API
              FutureBuilder<GetServices>(
                future: futureService,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    return const Center(child: Text("No services available"));
                  }

                  final servicesList = snapshot.data!.data;

                  return GridView.builder(
                    itemCount: servicesList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final s = servicesList[index];
                      return GestureDetector(
                        onTap: () {
                          context.push(DetailServicePage(service: s));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: (s.servicePhotoUrl.isNotEmpty)
                                      ? Image.network(
                                          s.servicePhotoUrl,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stack) =>
                                                  const Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                  ),
                                        )
                                      : Container(
                                          width: double.infinity,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image,
                                            size: 50,
                                          ),
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  s.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    PreferenceHandler.removeLogin();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const OnboardingPage()),
                    );
                  },
                  child: const Text(
                    "LOG OUT",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      // bottomNavigationBar: Botbar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
