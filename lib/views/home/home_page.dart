import 'package:barber/data/api/register_api.dart';
import 'package:barber/data/api/service_api.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:barber/model/user/get_user.dart';
import 'package:barber/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});
  static const id = "/dashboard";

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final int _currentIndex = 0; // boleh diubah nanti
  late Future<GetServices> futureService;
  late Future<GetUserModel>? futureUser;
  String query = "";

  int activeIndex = 0;
  final controller = CarouselController();
  final List<Map<String, dynamic>> infoList = [
    {
      "icon": Icons.access_time,
      "color": Colors.amber,
      "title": "JAM OPERASIONAL",
      "subtitle": "Open Senin - Minggu\n10.00 – 21.00 (Last order 20.30)",
    },
    {
      "icon": Icons.location_on,
      "color": Colors.red,
      "title": "LOKASI",
      "subtitle": "Jl. Merdeka No. 45, Jakarta",
    },
    {
      "icon": Iconsax.whatsapp,
      "color": Colors.green,
      "title": "LAYANAN PELANGGAN",
      "subtitle": "0812-8077-7736",
    },
  ];
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
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.darkRed.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 28,
                        color: AppColors.darkRed,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Nama + Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FutureBuilder<GetUserModel>(
                            future: futureUser,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  "Welcome, ...",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                );
                              } else if (snapshot.hasError ||
                                  snapshot.data?.data == null) {
                                return Text(
                                  "Welcome, User",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                );
                              } else {
                                final user = snapshot.data!.data!;
                                return Text(
                                  "Hi, ${user.name} 👋",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                );
                              }
                            },
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Get sharp, feel confident, only at KongCuts!",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icon Notifikasi
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.darkRed.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_none_outlined,
                          color: AppColors.darkRed,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Banner Promo
              CarouselSlider(
                options: CarouselOptions(
                  height: 350,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items:
                    [
                      "assets/images/banner_promo.png",
                      "assets/images/poto_pomade1.png",
                      "assets/images/poto_tempat.png",
                    ].map((imgPath) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: AssetImage(imgPath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                      0.7,
                                    ), // background biar jelas
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    "assets/images/logo_kongcuts_fix.png",
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }).toList(),
              ),
              SizedBox(height: 5),
              Column(
                children: [
                  CarouselSlider.builder(
                    // carouselController: controller,
                    itemCount: infoList.length,
                    itemBuilder: (context, index, realIndex) {
                      final item = infoList[index];
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 30,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: item["color"].withOpacity(0.2),
                              child: Icon(
                                item["icon"],
                                color: item["color"],
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 15),
                            Text(
                              item["title"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item["subtitle"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 200,
                      viewportFraction: 1.0,
                      enableInfiniteScroll: false,
                      autoPlay: false, // manual
                      onPageChanged: (index, reason) =>
                          setState(() => activeIndex = index),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: infoList.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.black,
                      dotColor: Colors.grey,
                    ),
                    // onDotClicked: (index) =>
                    //     controller.animateToPage(index),
                  ),
                ],
              ),

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

              // FutureBuilder<GetServices>(
              //   future: futureService,
              //   builder: (context, snapshot) {
              //     if (snapshot.connectionState == ConnectionState.waiting) {
              //       return const Center(child: CircularProgressIndicator());
              //     } else if (snapshot.hasError) {
              //       return Center(child: Text("Error: ${snapshot.error}"));
              //     } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              //       return const Center(child: Text("No services available"));
              //     }

              //     final servicesList = snapshot.data!.data;

              //     return GridView.builder(
              //       itemCount: servicesList.length,
              //       shrinkWrap: true,
              //       physics: const NeverScrollableScrollPhysics(),
              //       gridDelegate:
              //           const SliverGridDelegateWithFixedCrossAxisCount(
              //             crossAxisCount: 2,
              //             crossAxisSpacing: 15,
              //             mainAxisSpacing: 15,
              //             childAspectRatio: 0.8,
              //           ),
              //       itemBuilder: (context, index) {
              //         final s = servicesList[index];
              //         return Container(
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Expanded(
              //                 child: ClipRRect(
              //                   borderRadius: const BorderRadius.vertical(
              //                     top: Radius.circular(12),
              //                   ),
              //                   child: (s.servicePhotoUrl.isNotEmpty)
              //                       ? Image.network(
              //                           s.servicePhotoUrl,
              //                           width: double.infinity,
              //                           fit: BoxFit.cover,
              //                           errorBuilder: (context, error, stack) =>
              //                               const Icon(
              //                                 Icons.broken_image,
              //                                 size: 50,
              //                               ),
              //                         )
              //                       : Container(
              //                           width: double.infinity,
              //                           color: Colors.grey[300],
              //                           child: const Icon(
              //                             Icons.image,
              //                             size: 50,
              //                           ),
              //                         ),
              //                 ),
              //               ),
              //               Padding(
              //                 padding: const EdgeInsets.all(8.0),
              //                 child: Text(
              //                   s.name,
              //                   style: TextStyle(
              //                     fontWeight: FontWeight.w600,
              //                     color: AppColors.black,
              //                   ),
              //                   maxLines: 2,
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
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

                  // Urutkan supaya terbaru tampil duluan
                  final servicesList = snapshot.data!.data.take(6).toList();

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

              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.yellow,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     onPressed: () {
              //       PreferenceHandler.removeLogin();
              //       Navigator.pushReplacement(
              //         context,
              //         MaterialPageRoute(builder: (_) => const OnboardingPage()),
              //       );
              //     },
              //     child: const Text(
              //       "LOG OUT",
              //       style: TextStyle(
              //         fontFamily: "Poppins",
              //         fontSize: 18,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
