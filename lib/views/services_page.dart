import 'dart:io';

import 'package:barber/services/api/service_api.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddServicesPage extends StatefulWidget {
  const AddServicesPage({super.key});

  @override
  State<AddServicesPage> createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _employeeNameController = TextEditingController();

  File? _employeePhoto;
  File? _servicePhoto;

  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isEmployee) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isEmployee) {
          _employeePhoto = File(picked.path);
        } else {
          _servicePhoto = File(picked.path);
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_employeePhoto == null || _servicePhoto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Foto karyawan & service wajib dipilih")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthenticationAPIServices.addService(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: int.parse(_priceController.text.trim()),
        employeeName: _employeeNameController.text.trim(),
        employeePhoto: _employeePhoto!,
        servicePhoto: _servicePhoto!,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service berhasil ditambahkan")),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Service"),
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Service",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: "Harga",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employeeNameController,
                decoration: const InputDecoration(
                  labelText: "Nama Karyawan",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // Foto Karyawan
              Text(
                "Foto Karyawan",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _employeePhoto == null
                  ? Text("Belum ada foto")
                  : Image.file(_employeePhoto!, height: 150),
              TextButton.icon(
                onPressed: () => _pickImage(true),
                icon: const Icon(Icons.upload_file),
                label: const Text("Pilih Foto Karyawan"),
              ),
              const SizedBox(height: 16),

              // Foto Service
              Text(
                "Foto Service",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _servicePhoto == null
                  ? Text("Belum ada foto")
                  : Image.file(_servicePhoto!, height: 150),
              TextButton.icon(
                onPressed: () => _pickImage(false),
                icon: Icon(Icons.upload_file),
                label: Text("Pilih Foto Service"),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[900],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Tambah Service", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _employeeNameController.dispose();
    super.dispose();
  }
}
