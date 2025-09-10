import 'package:barber/data/api/service_api.dart';
import 'package:barber/extensions/extensions.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:barber/utils/utils.dart';
import 'package:barber/views/services/detail_services_page.dart';
import 'package:flutter/material.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});
  static const id = "/services";

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  late Future<GetServices> futureService;
  String query = "";

  @override
  void initState() {
    super.initState();
    futureService = AuthenticationAPIServices.getService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // putih tulang background
      body: Column(
        children: [
          // Header
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      "Our Services",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900, // lebih bold
                        color: AppColors.black, // merah bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Search bar
          SizedBox(
            width: 340, // lebih ramping
            height: 42,
            child: TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: "Search services...",
                hintStyle: const TextStyle(
                  color: Color(0xFF9E9E9E),
                ), // abu medium
                prefixIcon: const Icon(
                  Icons.search,
                  color: Color(0xFF616161),
                ), // abu tua
                filled: true,
                fillColor: const Color(
                  0xFFF5F5F5,
                ), // abu muda biar kontras dengan background
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Services List
          Expanded(
            child: FutureBuilder<GetServices>(
              future: futureService,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return const Center(child: Text("No services available"));
                }

                // Ambil 6 terbaru + filter search
                final servicesList = snapshot.data!.data.reversed
                    .take(6)
                    .where(
                      (s) => s.name.toLowerCase().contains(query.toLowerCase()),
                    )
                    .toList();

                if (servicesList.isEmpty) {
                  return const Center(child: Text("No matching services"));
                }

                return GridView.builder(
                  itemCount: servicesList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.8,
                  ),
                  padding: const EdgeInsets.only(
                    bottom: 50,
                    left: 10,
                    right: 10,
                  ),
                  itemBuilder: (context, index) {
                    final s = servicesList[index];
                    return GestureDetector(
                      onTap: () {
                        context.push(DetailServicePage(service: s));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(
                            16,
                          ), // radius lebih bulat
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.1,
                              ), // shadow halus
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Foto Service
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
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
                                              color: Color(0xFF616161),
                                            ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        color: const Color(
                                          0xFFE0E0E0,
                                        ), // abu muda fallback
                                        child: const Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Color(0xFF616161), // abu tua
                                        ),
                                      ),
                              ),
                            ),

                            // Nama Service
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                s.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(
                                    0xFF212121,
                                  ), // abu gelap untuk teks
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
          ),
        ],
      ),
    );
  }
}
