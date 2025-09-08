import 'package:barber/extensions/extensions.dart';
import 'package:barber/views/settings/admin%20_page.dart';
import 'package:barber/views/settings/admin_list_services.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isNotificationOn = true;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC), // beige background
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Pengaturan", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          SizedBox(height: 10),
          // Notifikasi
          SwitchListTile(
            activeColor: Colors.red,
            title: const Text("Notifikasi"),
            value: isNotificationOn,
            onChanged: (val) {
              setState(() {
                isNotificationOn = val;
              });
            },
          ),
          // Mode Gelap
          SwitchListTile(
            activeColor: Colors.red,
            title: const Text("Mode Gelap"),
            value: isDarkMode,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
              });
            },
          ),
          Divider(),
          // Lain-lain
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Colors.red),
            title: const Text("Masuk sebagai Admin"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.push(AdminServicePage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Colors.red),
            title: const Text("Masuk sebagai Admin 2"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.push(AdminServiceListPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.red),
            title: const Text("Privasi & Keamanan"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Tambah page privasi kalau perlu
            },
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.red),
            title: const Text("Bantuan"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Tambah page bantuan kalau perlu
            },
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.red),
            title: const Text("Tentang Aplikasi"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Tambah page tentang kalau perlu
            },
          ),
        ],
      ),
    );
  }
}
