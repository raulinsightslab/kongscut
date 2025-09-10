import 'dart:io';

import 'package:barber/data/api/service_api.dart';
import 'package:barber/model/service/get_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminServiceFormPage extends StatefulWidget {
  final DetailServices? service;
  final VoidCallback? onServiceSaved;

  const AdminServiceFormPage({super.key, this.service, this.onServiceSaved});

  @override
  State<AdminServiceFormPage> createState() => _AdminServiceFormPageState();
}

class _AdminServiceFormPageState extends State<AdminServiceFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? _newEmployeePhoto;
  XFile? _newServicePhoto;
  bool _isLoading = false;
  bool _employeePhotoChanged = false;
  bool _servicePhotoChanged = false;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      nameController.text = widget.service!.name;
      descriptionController.text = widget.service!.description;
      priceController.text = widget.service!.price;
      employeeNameController.text = widget.service!.employeeName;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final price = int.tryParse(priceController.text);
      if (price == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Harga harus berupa angka")),
        );
        setState(() => _isLoading = false);
        return;
      }

      // Untuk CREATE service baru
      if (widget.service == null) {
        if (_newServicePhoto == null || _newEmployeePhoto == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Foto service dan pegawai wajib diisi"),
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        await AuthenticationAPIServices.postService(
          name: nameController.text,
          description: descriptionController.text,
          price: price,
          employeeName: employeeNameController.text,
          servicePhoto: File(_newServicePhoto!.path),
          employeePhoto: File(_newEmployeePhoto!.path),
        );
      }
      // Untuk UPDATE service yang ada
      else {
        // Jika user tidak memilih foto baru, kita perlu strategi lain
        // Karena API mengharuskan mengirim kedua foto

        if (!_servicePhotoChanged || !_employeePhotoChanged) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Untuk update, silakan pilih foto baru untuk service dan pegawai",
              ),
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        await AuthenticationAPIServices.updateService(
          id: widget.service!.id,
          name: nameController.text,
          description: descriptionController.text,
          price: price,
          employeeName: employeeNameController.text,
          servicePhoto: File(_newServicePhoto!.path),
          employeePhoto: File(_newEmployeePhoto!.path),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.service == null
                ? "Service berhasil ditambahkan"
                : "Service berhasil diperbarui",
          ),
          backgroundColor: Colors.green,
        ),
      );

      widget.onServiceSaved?.call();
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickEmployeePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _newEmployeePhoto = image;
        _employeePhotoChanged = true;
      });
    }
  }

  Future<void> _pickServicePhoto() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _newServicePhoto = image;
        _servicePhotoChanged = true;
      });
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
                    _buildTextField(nameController, "Nama Service", Icons.spa),
                    const SizedBox(height: 16),
                    _buildTextField(
                      descriptionController,
                      "Deskripsi Service",
                      Icons.description,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      priceController,
                      "Harga",
                      Icons.money,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      employeeNameController,
                      "Nama Pegawai",
                      Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      "Foto Pegawai",
                      _newEmployeePhoto,
                      widget.service?.employeePhotoUrl,
                      _pickEmployeePhoto,
                      isRequired: widget.service == null,
                    ),
                    const SizedBox(height: 16),
                    _buildImagePicker(
                      "Foto Service",
                      _newServicePhoto,
                      widget.service?.servicePhotoUrl,
                      _pickServicePhoto,
                      isRequired: widget.service == null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(
                        widget.service == null
                            ? "Tambah Service"
                            : "Update Service",
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: (v) =>
          v == null || v.isEmpty ? "$label tidak boleh kosong" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildImagePicker(
    String label,
    XFile? newImage,
    String? existingImageUrl,
    VoidCallback onPick, {
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label ${isRequired ? '*' : ''}"),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(onPressed: onPick, child: const Text("Pilih Foto")),
            const SizedBox(width: 12),
            if (newImage != null)
              Image.file(
                File(newImage.path),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
            else if (existingImageUrl != null && existingImageUrl.isNotEmpty)
              Image.network(
                existingImageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                color: Colors.grey[300],
                child: const Icon(Icons.image),
              ),
          ],
        ),
        if (widget.service != null && !isRequired)
          const Text(
            "Pilih foto baru untuk mengupdate",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
      ],
    );
  }
}
