import 'package:flutter/material.dart';
import 'package:barber/data/api/register_api.dart';
import 'package:barber/data/api/service_api.dart';
import 'package:barber/data/local/shared_preferences.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:barber/model/user/get_user.dart';
import 'package:barber/utils/utils.dart';
import 'package:barber/views/auth/onboarding_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const id = "/dashboard";

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0; // boleh diubah nanti
  late Future<GetServices> futureService;
  Future<GetUserModel>? futureUser;

  @override
  void initState() {
    super.initState();
    futureService = AuthenticationAPIServices.getService();
    futureUser = AuthenticationAPI.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                children: [
                  // Nama user
                  Expanded(
                    child: FutureBuilder<GetUserModel>(
                      future: futureUser,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                            "Welcome, ...",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else if (snapshot.hasError ||
                            snapshot.data?.data == null) {
                          return const Text(
                            "Welcome, User",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          final user = snapshot.data!.data!;
                          return Text(
                            "Hi, ${user.name} 👋",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // Icon notifikasi tetap di kanan
                  Icon(Icons.notifications, color: AppColors.darkRed),
                ],
              ),

              SizedBox(height: 20),
              // Banner Promo
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.darkRed,
                  image: const DecorationImage(
                    image: AssetImage("assets/images/logo_kongcuts_fix.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Unpaid Bookings
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.warning, color: AppColors.darkRed),
                  title: const Text("2 Unpaid Bookings"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Pay Now"),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Categories dari API
              Text(
                "Our Services",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 10),

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
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.8,
                        ),
                    itemBuilder: (context, index) {
                      final s = servicesList[index];
                      return Container(
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
                                        errorBuilder: (context, error, stack) =>
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
    );
  }
}
