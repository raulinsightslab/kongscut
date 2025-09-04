import 'package:barber/extensions/extensions.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:barber/services/api/service_api.dart';
import 'package:barber/services/local/shared_preferences.dart';
import 'package:barber/utils/utils.dart';
import 'package:barber/views/onboarding_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const id = "/dashboard";

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final int _currentIndex = 0;
  late Future<GetServices> futureService;
  // Future<void> _deleteService(String name) async {
  //   try {
  //     await AuthenticationAPIServices.deleteService(name: name);
  //     // Refresh data setelah delete
  //     setState(() {
  //       futureService = AuthenticationAPIServices.getService();
  //     });
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Service $name berhasil dihapus")));
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Gagal hapus service: $e")));
  //   }
  // }

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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hi Client, 👋",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  Icon(Icons.notifications, color: AppColors.darkRed),
                ],
              ),
              const SizedBox(height: 20),

              // Banner Promo
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.darkRed,
                  image: DecorationImage(
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

              FutureBuilder(
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      final s = servicesList[index];
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: s.servicePhotoUrl.isNotEmpty
                                        ? Image.network(
                                            s.servicePhotoUrl,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: double.infinity,
                                            color: Colors.grey[300],
                                            child: Icon(Icons.image, size: 50),
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
                          // Tombol delete di pojok kanan atas
                          // Positioned(
                          //   top: 4,
                          //   right: 4,
                          //   child: IconButton(
                          //     icon: Icon(Icons.delete, color: Colors.red),
                          //     onPressed: () {
                          //       _deleteService(s.name);
                          //     },
                          //   ),
                          // ),
                        ],
                      );
                    },
                  );
                },
              ),

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
                    context.pushReplacement(OnboardingPage());
                  },
                  child: Text(
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

  // Widget _serviceCard(String title, String imageUrl) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: AppColors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 5,
  //           offset: const Offset(2, 2),
  //         ),
  //       ],
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Image.network(
  //           imageUrl,
  //           height: 60,
  //           errorBuilder: (context, error, stackTrace) =>
  //               const Icon(Icons.broken_image, size: 60),
  //         ),
  //         const SizedBox(height: 10),
  //         Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: AppColors.black,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
