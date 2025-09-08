import 'dart:io';
import 'package:barber/data/api/service_api.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:barber/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminServicePage extends StatefulWidget {
  const AdminServicePage({super.key});

  @override
  State<AdminServicePage> createState() => _AdminServicePageState();
}

class _AdminServicePageState extends State<AdminServicePage> {
  late Future<GetServices> futureServices;

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _employeeCtrl = TextEditingController();

  File? _servicePhoto;
  File? _employeePhoto;
  DetailServices? _editingService;

  final picker = ImagePicker();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    futureServices = AuthenticationAPIServices.getService();
  }

  void refreshServices() {
    setState(() {
      futureServices = AuthenticationAPIServices.getService();
    });
  }

  // 📌 Pilih foto
  Future<File?> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) return File(picked.path);
    return null;
  }

  // 📌 Simpan service (tambah / update)
  void saveService() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi foto untuk create baru
    if (_editingService == null) {
      if (_servicePhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Foto service diperlukan")),
        );
        return;
      }
      if (_employeePhoto == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Foto employee diperlukan")),
        );
        return;
      }
    }

    try {
      if (_editingService == null) {
        // Tambah baru
        await AuthenticationAPIServices.postService(
          name: _nameCtrl.text,
          description: _descCtrl.text,
          price: int.parse(_priceCtrl.text),
          employeeName: _employeeCtrl.text,
          servicePhoto: _servicePhoto!,
          employeePhoto: _employeePhoto!,
        );
      } else {
        // Update
        await AuthenticationAPIServices.updateService(
          id: _editingService!.id,
          name: _nameCtrl.text,
          description: _descCtrl.text,
          price: double.parse(_priceCtrl.text),
          employeeName: _employeeCtrl.text,
          servicePhoto: _servicePhoto,
          employeePhoto: _employeePhoto,
        );
      }

      // reset form
      clearForm();
      refreshServices();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryRed,
          content: Text(
            _editingService == null
                ? "✅ Service berhasil ditambahkan"
                : "✅ Service berhasil diperbarui",
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.darkRed,
          content: Text("❌ Error: $e"),
        ),
      );
    }
  }

  void clearForm() {
    _formKey.currentState?.reset();
    _nameCtrl.clear();
    _descCtrl.clear();
    _priceCtrl.clear();
    _employeeCtrl.clear();
    _servicePhoto = null;
    _employeePhoto = null;
    _editingService = null;
    setState(() {});
  }

  void editService(DetailServices service) {
    setState(() {
      _editingService = service;
      _nameCtrl.text = service.name;
      _descCtrl.text = service.description;
      _priceCtrl.text = service.price.toString();
      _employeeCtrl.text = service.employeeName ?? "";
      _servicePhoto = null;
      _employeePhoto = null;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: const Text(
          "Kelola Services",
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryRed,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Column(
        children: [
          // 📌 FORM TAMBAH / UPDATE
          // Expanded(
          //   flex: _editingService == null ? 2 : 3,
          //   child: SingleChildScrollView(
          //     padding: const EdgeInsets.all(16.0),
          //     child: Form(
          //       key: _formKey,
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             _editingService == null
          //                 ? "Tambah Service Baru"
          //                 : "Edit Service - ${_editingService!.name}",
          //             style: const TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //               color: AppColors.darkGrey,
          //             ),
          //           ),
          //           const SizedBox(height: 16),

          //           TextFormField(
          //             controller: _nameCtrl,
          //             decoration: InputDecoration(
          //               labelText: "Nama Service",
          //               labelStyle: const TextStyle(color: AppColors.darkGrey),
          //               border: OutlineInputBorder(
          //                 borderSide: const BorderSide(
          //                   color: AppColors.accentBrown,
          //                 ),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide: const BorderSide(
          //                   color: AppColors.primaryRed,
          //                 ),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //             ),
          //             style: const TextStyle(color: AppColors.black),
          //             validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
          //           ),
          //           const SizedBox(height: 12),

          //           TextFormField(
          //             controller: _descCtrl,
          //             decoration: InputDecoration(
          //               labelText: "Deskripsi",
          //               labelStyle: const TextStyle(color: AppColors.darkGrey),
          //               border: OutlineInputBorder(
          //                 borderSide: const BorderSide(
          //                   color: AppColors.accentBrown,
          //                 ),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide: const BorderSide(
          //                   color: AppColors.primaryRed,
          //                 ),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //             ),
          //             style: const TextStyle(color: AppColors.black),
          //             maxLines: 2,
          //             validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
          //           ),
          //           const SizedBox(height: 12),

          //           TextFormField(
          //             controller: _priceCtrl,
          //             decoration: InputDecoration(
          //               labelText: "Harga",
          //               labelStyle: const TextStyle(color: AppColors.darkGrey),
          //               border: OutlineInputBorder(
          //                 borderSide: const BorderSide(
          //                   color: AppColors.accentBrown,
          //                 ),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide: const BorderSide(
          //                   color: AppColors.primaryRed,
          //                 ),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //               prefixText: "Rp ",
          //               prefixStyle: const TextStyle(color: AppColors.black),
          //             ),
          //             style: const TextStyle(color: AppColors.black),
          //             keyboardType: TextInputType.number,
          //             validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
          //           ),
          //           const SizedBox(height: 12),

          //           TextFormField(
          //             controller: _employeeCtrl,
          //             decoration: InputDecoration(
          //               labelText: "Nama Pegawai",
          //               labelStyle: const TextStyle(color: AppColors.darkGrey),
          //               border: OutlineInputBorder(
          //                 borderSide: const BorderSide(
          //                   color: AppColors.accentBrown,
          //                 ),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //               focusedBorder: OutlineInputBorder(
          //                 borderSide: const BorderSide(
          //                   color: AppColors.primaryRed,
          //                 ),
          //                 borderRadius: BorderRadius.circular(8),
          //               ),
          //             ),
          //             style: const TextStyle(color: AppColors.black),
          //             validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
          //           ),
          //           const SizedBox(height: 16),

          //           // Foto Section
          //           const Text(
          //             "Foto:",
          //             style: TextStyle(
          //               fontWeight: FontWeight.bold,
          //               color: AppColors.darkGrey,
          //             ),
          //           ),
          //           const SizedBox(height: 8),

          //           Row(
          //             children: [
          //               Expanded(
          //                 child: Column(
          //                   children: [
          //                     ElevatedButton.icon(
          //                       icon: const Icon(
          //                         Icons.image,
          //                         size: 18,
          //                         color: AppColors.white,
          //                       ),
          //                       label: const Text(
          //                         "Foto Service",
          //                         style: TextStyle(color: AppColors.white),
          //                       ),
          //                       style: ElevatedButton.styleFrom(
          //                         backgroundColor: AppColors.primaryRed,
          //                         padding: const EdgeInsets.symmetric(
          //                           vertical: 12,
          //                           horizontal: 8,
          //                         ),
          //                       ),
          //                       onPressed: () async {
          //                         final file = await pickImage();
          //                         if (file != null) {
          //                           setState(() => _servicePhoto = file);
          //                         }
          //                       },
          //                     ),
          //                     const SizedBox(height: 4),
          //                     Text(
          //                       _servicePhoto != null
          //                           ? "Foto terpilih"
          //                           : _editingService != null
          //                           ? "Gunakan foto lama"
          //                           : "Wajib dipilih",
          //                       style: TextStyle(
          //                         fontSize: 12,
          //                         color: _servicePhoto != null
          //                             ? AppColors.primaryRed
          //                             : AppColors.grey,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               const SizedBox(width: 12),

          //               Expanded(
          //                 child: Column(
          //                   children: [
          //                     ElevatedButton.icon(
          //                       icon: const Icon(
          //                         Icons.person,
          //                         size: 18,
          //                         color: AppColors.white,
          //                       ),
          //                       label: const Text(
          //                         "Foto Pegawai",
          //                         style: TextStyle(color: AppColors.white),
          //                       ),
          //                       style: ElevatedButton.styleFrom(
          //                         backgroundColor: AppColors.primaryRed,
          //                         padding: const EdgeInsets.symmetric(
          //                           vertical: 12,
          //                           horizontal: 8,
          //                         ),
          //                       ),
          //                       onPressed: () async {
          //                         final file = await pickImage();
          //                         if (file != null) {
          //                           setState(() => _employeePhoto = file);
          //                         }
          //                       },
          //                     ),
          //                     const SizedBox(height: 4),
          //                     Text(
          //                       _employeePhoto != null
          //                           ? "Foto terpilih"
          //                           : _editingService != null
          //                           ? "Gunakan foto lama"
          //                           : "Wajib dipilih",
          //                       style: TextStyle(
          //                         fontSize: 12,
          //                         color: _employeePhoto != null
          //                             ? AppColors.primaryRed
          //                             : AppColors.grey,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const SizedBox(height: 16),

          //           // Action Buttons
          //           Row(
          //             children: [
          //               Expanded(
          //                 child: ElevatedButton(
          //                   onPressed: saveService,
          //                   style: ElevatedButton.styleFrom(
          //                     backgroundColor: AppColors.primaryRed,
          //                     foregroundColor: AppColors.white,
          //                     padding: const EdgeInsets.symmetric(vertical: 16),
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(8),
          //                     ),
          //                   ),
          //                   child: Text(
          //                     _editingService == null
          //                         ? "TAMBAH SERVICE"
          //                         : "UPDATE SERVICE",
          //                     style: const TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               if (_editingService != null) ...[
          //                 const SizedBox(width: 12),
          //                 OutlinedButton(
          //                   onPressed: clearForm,
          //                   style: OutlinedButton.styleFrom(
          //                     side: const BorderSide(
          //                       color: AppColors.primaryRed,
          //                     ),
          //                     padding: const EdgeInsets.symmetric(
          //                       vertical: 16,
          //                       horizontal: 20,
          //                     ),
          //                     shape: RoundedRectangleBorder(
          //                       borderRadius: BorderRadius.circular(8),
          //                     ),
          //                   ),
          //                   child: const Text(
          //                     "BATAL",
          //                     style: TextStyle(color: AppColors.primaryRed),
          //                   ),
          //                 ),
          //               ],
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          const Divider(height: 1, thickness: 1, color: AppColors.accentBrown),

          // 📌 LIST SERVICES
          Expanded(
            flex: 3,
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
                    child: SingleChildScrollView(
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
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt, size: 48, color: AppColors.grey),
                        SizedBox(height: 16),
                        Text(
                          "Belum ada services",
                          style: TextStyle(color: AppColors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final services = snapshot.data!.data;
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      color: AppColors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
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
                            if (service.employeeName != null)
                              Text(
                                "Pegawai: ${service.employeeName!}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 80,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                color: AppColors.primaryRed,
                                onPressed: () => editService(service),
                              ),
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
    );
  }
}
