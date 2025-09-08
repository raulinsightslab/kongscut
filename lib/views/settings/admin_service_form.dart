import 'dart:io';
import 'package:barber/data/api/service_api.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:barber/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminServiceFormPage extends StatefulWidget {
  static const id = "/admin";
  final DetailServices? service;
  final VoidCallback onServiceSaved;

  const AdminServiceFormPage({
    super.key,
    this.service,
    required this.onServiceSaved,
  });

  @override
  State<AdminServiceFormPage> createState() => _AdminServiceFormPageState();
}

class _AdminServiceFormPageState extends State<AdminServiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _employeeCtrl = TextEditingController();

  File? _servicePhoto;
  File? _employeePhoto;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _nameCtrl.text = widget.service!.name;
      _descCtrl.text = widget.service!.description;
      _priceCtrl.text = widget.service!.price.toString();
      _employeeCtrl.text = widget.service!.employeeName ?? "";
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _employeeCtrl.dispose();
    super.dispose();
  }

  Future<File?> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) return File(picked.path);
    return null;
  }

  void saveService() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi foto untuk create baru
    if (widget.service == null) {
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
      if (widget.service == null) {
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
          id: widget.service!.id,
          name: _nameCtrl.text,
          description: _descCtrl.text,
          price: double.parse(_priceCtrl.text),
          employeeName: _employeeCtrl.text,
          servicePhoto: _servicePhoto,
          employeePhoto: _employeePhoto,
        );
      }

      widget.onServiceSaved();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.primaryRed,
          content: Text(
            widget.service == null
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      appBar: AppBar(
        title: Text(
          widget.service == null ? "Tambah Service" : "Edit Service",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primaryRed,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: "Nama Service",
                  labelStyle: const TextStyle(color: AppColors.darkGrey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accentBrown),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: AppColors.black),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descCtrl,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  labelStyle: const TextStyle(color: AppColors.darkGrey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accentBrown),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: AppColors.black),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _priceCtrl,
                decoration: InputDecoration(
                  labelText: "Harga",
                  labelStyle: const TextStyle(color: AppColors.darkGrey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accentBrown),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixText: "Rp ",
                  prefixStyle: const TextStyle(color: AppColors.black),
                ),
                style: const TextStyle(color: AppColors.black),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _employeeCtrl,
                decoration: InputDecoration(
                  labelText: "Nama Pegawai",
                  labelStyle: const TextStyle(color: AppColors.darkGrey),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.accentBrown),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primaryRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: AppColors.black),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 24),

              // Foto Section
              const Text(
                "Foto:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.image,
                            size: 18,
                            color: AppColors.white,
                          ),
                          label: const Text(
                            "Foto Service",
                            style: TextStyle(color: AppColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () async {
                            final file = await pickImage();
                            if (file != null) {
                              setState(() => _servicePhoto = file);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _servicePhoto != null
                              ? "Foto terpilih"
                              : widget.service != null
                              ? "Gunakan foto lama"
                              : "Wajib dipilih",
                          style: TextStyle(
                            fontSize: 12,
                            color: _servicePhoto != null
                                ? AppColors.primaryRed
                                : AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.person,
                            size: 18,
                            color: AppColors.white,
                          ),
                          label: const Text(
                            "Foto Pegawai",
                            style: TextStyle(color: AppColors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () async {
                            final file = await pickImage();
                            if (file != null) {
                              setState(() => _employeePhoto = file);
                            }
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _employeePhoto != null
                              ? "Foto terpilih"
                              : widget.service != null
                              ? "Gunakan foto lama"
                              : "Wajib dipilih",
                          style: TextStyle(
                            fontSize: 12,
                            color: _employeePhoto != null
                                ? AppColors.primaryRed
                                : AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    widget.service == null
                        ? "SIMPAN SERVICE"
                        : "UPDATE SERVICE",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
