import 'package:barber/data/api/register_api.dart';
import 'package:barber/data/local/shared_preferences.dart';
import 'package:barber/extensions/extensions.dart';
import 'package:barber/model/user/get_user.dart';
import 'package:barber/utils/utils.dart';
import 'package:barber/views/auth/onboarding_page.dart';
import 'package:barber/views/profile/edit_profile.dart';
import 'package:barber/views/profile/settings_page.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<GetUserModel>? futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = AuthenticationAPI.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite, // beige background
      // appBar: AppBar(
      //   backgroundColor: Colors.red,
      //   title: const Text("Profil Saya", style: TextStyle(color: Colors.white)),
      //   centerTitle: true,
      //   iconTheme: IconThemeData(color: Colors.white),
      // ),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: const BorderRadius.only(
                    // bottomLeft: Radius.circular(20),
                    // bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black,
                      // blurRadius: 2,
                      // offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(
                    child: Text(
                      "My Profile",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold, // lebih bold
                        color: AppColors.black, // merah bold
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Foto profil
          CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          SizedBox(height: 20),
          // const Text(
          //   "Raul Akbar",
          //   style: TextStyle(
          //     fontSize: 22,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.black87,
          //   ),
          // ),
          // const SizedBox(height: 4),
          // const Text(
          //   "raul.akbar@email.com",
          //   style: TextStyle(color: Colors.grey),
          // ),
          // SizedBox(height: 24),
          FutureBuilder<GetUserModel>(
            future: futureUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  "Welcome, ...",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                );
              } else if (snapshot.hasError || snapshot.data?.data == null) {
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
                return Column(
                  children: [
                    Text(
                      "${user.name} ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black,
                      ),
                    ),
                    Text(
                      "${user.email} ",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 18),
          // Menu profil
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.red),
                  title: const Text("Edit Profil"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.push(EditProfilePage());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.red),
                  title: const Text("Riwayat Booking"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.red),
                  title: const Text("Pengaturan"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    context.push(SettingsPage());
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Keluar"),
                  // trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // context.pushNamedAndRemoveAll(OnboardingPage.id);
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Logout Confirmation",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Are you sure you want to log out?",
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        // PreferenceHandler.removeUserId();
                                        PreferenceHandler.removeToken();
                                        PreferenceHandler.removeLogin();

                                        Navigator.pop(context);
                                        context.pushReplacement(
                                          const OnboardingPage(),
                                        );
                                      },
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(
                                          fontFamily: "Montserrat",
                                          color: AppColors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
