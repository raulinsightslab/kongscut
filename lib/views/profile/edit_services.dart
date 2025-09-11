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

  bool _isLoading = false;
  bool _servicePhotoChanged = false;
  bool _employeePhotoChanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _nameCtrl.text = widget.service!.name;
      _descCtrl.text = widget.service!.description;
      _priceCtrl.text = widget.service!.price;
      _employeeCtrl.text = widget.service!.employeeName;
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

  Future<void> pickImage(bool isServicePhoto) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isServicePhoto) {
          _servicePhoto = File(picked.path);
          _servicePhotoChanged = true;
        } else {
          _employeePhoto = File(picked.path);
          _employeePhotoChanged = true;
        }
      });
    }
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

    int? price;
    try {
      price = int.parse(_priceCtrl.text);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Harga harus berupa angka")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.service == null) {
        // Create baru
        await AuthenticationAPIServices.postService(
          name: _nameCtrl.text,
          description: _descCtrl.text,
          price: price,
          employeeName: _employeeCtrl.text,
          servicePhoto: _servicePhoto!,
          employeePhoto: _employeePhoto!,
        );
      } else {
        // Update service
        // Hanya kirim foto yang diubah
        File? servicePhotoFile = _servicePhotoChanged ? _servicePhoto : null;
        File? employeePhotoFile = _employeePhotoChanged ? _employeePhoto : null;

        await AuthenticationAPIServices.updateService(
          id: widget.service!.id,
          name: _nameCtrl.text,
          description: _descCtrl.text,
          price: price,
          employeeName: _employeeCtrl.text,
          servicePhoto: servicePhotoFile,
          employeePhoto: employeePhotoFile,
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
          content: Text("❌ Error: ${e.toString()}"),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.service == null ? "Tambah Service" : "Edit Service"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nama Service",
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Nama service wajib diisi" : null,
                    ),
                    TextFormField(
                      controller: _descCtrl,
                      decoration: const InputDecoration(labelText: "Deskripsi"),
                      validator: (v) =>
                          v!.isEmpty ? "Deskripsi wajib diisi" : null,
                    ),
                    TextFormField(
                      controller: _priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Harga"),
                      validator: (v) => v!.isEmpty ? "Harga wajib diisi" : null,
                    ),
                    TextFormField(
                      controller: _employeeCtrl,
                      decoration: const InputDecoration(
                        labelText: "Nama Pegawai",
                      ),
                      validator: (v) =>
                          v!.isEmpty ? "Nama pegawai wajib diisi" : null,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => pickImage(true),
                      child: const Text("Pilih Foto Service"),
                    ),
                    ElevatedButton(
                      onPressed: () => pickImage(false),
                      child: const Text("Pilih Foto Pegawai"),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: saveService,
                      child: const Text("Simpan"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
