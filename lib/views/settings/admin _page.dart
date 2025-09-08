import 'dart:io';

import 'package:barber/data/api/service_api.dart';
import 'package:barber/model/service/add_services_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  static const id = "/servis";

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  XFile? serviceFile;
  XFile? employeeFile;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController priceCtrl = TextEditingController();
  final TextEditingController employeeNameCtrl = TextEditingController();

  Future<void> pickServiceFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => serviceFile = image);
  }

  Future<void> pickEmployeeFoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => employeeFile = image);
  }

  Future<void> submitService() async {
    if (!_formKey.currentState!.validate()) return;
    if (serviceFile == null || employeeFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Pilih foto service & employee dulu")),
      );
      return;
    }

    try {
      final AddServices? response = await AuthenticationAPIServices.postService(
        name: nameCtrl.text,
        description: descCtrl.text,
        price: int.parse(priceCtrl.text),
        employeeName: employeeNameCtrl.text,
        servicePhoto: File(serviceFile!.path),
        employeePhoto: File(employeeFile!.path),
      );

      if (response != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ ${response.message}")));
        // Reset form
        nameCtrl.clear();
        descCtrl.clear();
        priceCtrl.clear();
        employeeNameCtrl.clear();
        setState(() {
          serviceFile = null;
          employeeFile = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Gagal tambah service: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Service")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: "Nama Service"),
                  validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                ),
                TextFormField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: "Deskripsi"),
                  validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                ),
                TextFormField(
                  controller: priceCtrl,
                  decoration: const InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                ),
                TextFormField(
                  controller: employeeNameCtrl,
                  decoration: const InputDecoration(labelText: "Nama Pegawai"),
                  validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 20),

                // Foto Service
                serviceFile != null
                    ? Image.file(File(serviceFile!.path), height: 100)
                    : const Text("Belum pilih foto service"),
                ElevatedButton(
                  onPressed: pickServiceFoto,
                  child: const Text("Pilih Foto Service"),
                ),

                const SizedBox(height: 20),

                // Foto Employee
                employeeFile != null
                    ? Image.file(File(employeeFile!.path), height: 100)
                    : const Text("Belum pilih foto employee"),
                ElevatedButton(
                  onPressed: pickEmployeeFoto,
                  child: const Text("Pilih Foto Employee"),
                ),

                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: submitService,
                  child: const Text("Tambah Service"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
