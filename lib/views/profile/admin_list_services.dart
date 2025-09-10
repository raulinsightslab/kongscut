import 'package:barber/data/api/service_api.dart';
import 'package:barber/extensions/extensions.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:barber/utils/utils.dart';
import 'package:flutter/material.dart';

import 'admin_service_form.dart';

class AdminServiceListPage extends StatefulWidget {
  const AdminServiceListPage({super.key});

  @override
  State<AdminServiceListPage> createState() => _AdminServiceListPageState();
}

class _AdminServiceListPageState extends State<AdminServiceListPage> {
  late Future<GetServices> futureServices;

  @override
  void initState() {
    super.initState();
    refreshServices();
  }

  void refreshServices() {
    setState(() {
      futureServices = AuthenticationAPIServices.getService();
    });
  }

  void deleteService(int id) async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus service ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Hapus",
              style: TextStyle(color: AppColors.primaryRed),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await AuthenticationAPIServices.deleteService(id);
        refreshServices();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.primaryRed,
            content: Text("✅ Service berhasil dihapus"),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.darkRed,
            content: Text("❌ Gagal menghapus: $e"),
          ),
        );
      }
    }
  }

  void navigateToForm({DetailServices? service}) {
    context.push(
      AdminServiceFormPage(service: service, onServiceSaved: refreshServices),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: SafeArea(
        child: Column(
          children: [
            // Judul + tombol Add
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  // Tombol Back
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: AppColors.darkGrey,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Kelola Services",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => navigateToForm(),
                    icon: Icon(Icons.add, size: 20, color: AppColors.white),
                    label: const Text(
                      "Add New Services",
                      style: TextStyle(color: AppColors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: FutureBuilder<GetServices>(
                future: futureServices,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryRed,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error,
                            size: 48,
                            color: AppColors.primaryRed,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Error: ${snapshot.error}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: AppColors.darkRed),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: refreshServices,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: AppColors.white,
                            ),
                            child: const Text("Coba Lagi"),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.list_alt,
                            size: 48,
                            color: AppColors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Belum ada services",
                            style: TextStyle(color: AppColors.grey),
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => navigateToForm(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: AppColors.white,
                            ),
                            child: const Text("Add New Service"),
                          ),
                        ],
                      ),
                    );
                  }

                  final services = snapshot.data!.data;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        color: AppColors.white,
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: AppColors.offWhite,
                            backgroundImage: NetworkImage(
                              service.servicePhotoUrl,
                            ),
                          ),
                          title: Text(
                            service.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: AppColors.grey),
                              ),
                              Text(
                                "Rp ${service.price}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                              Text(
                                "Pegawai: ${service.employeeName}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, size: 20),
                                  color: AppColors.primaryRed,
                                  onPressed: () =>
                                      navigateToForm(service: service),
                                ),
                                SizedBox(width: 1),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 20),
                                  color: AppColors.darkRed,
                                  onPressed: () => deleteService(service.id),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
