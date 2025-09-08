import 'package:barber/data/api/register_api.dart';
import 'package:barber/data/local/shared_preferences.dart';
import 'package:barber/model/user/regis_model.dart';
import 'package:barber/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const RegisPage());
}

class RegisPage extends StatefulWidget {
  const RegisPage({super.key});
  static const id = "/regis_page";

  @override
  State<RegisPage> createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsurePassword = true;
  RegisUserModel? user;
  String? errorMessage;
  bool isVisibility = false;
  bool isLoading = false;

  void registUser() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Name, Email, and Password cannot be empty"),
        ),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final results = await AuthenticationAPI.registerUser(
        email: email,
        password: password,
        name: name,
      );

      setState(() {
        user = results;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration was successful")),
      );

      PreferenceHandler.saveToken(user?.data.token.toString() ?? "");
      // context.pop(LoginPage());

      print(user?.toJson());
    } catch (e) {
      print(e);
      setState(() {
        errorMessage = e.toString();
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image.asset("assets/images/logo_kongcuts_fix.png"),
            // SizedBox(height: 20),
            //form login
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Name",
                hintText: "Enter Your Name",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                  borderRadius: BorderRadius.circular(30),
                  // labelStyle: TextStyle(color : AppColors.white)
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Email",
                hintText: "Enter Your Email",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                  borderRadius: BorderRadius.circular(30),
                  // labelStyle: TextStyle(color : AppColors.white)
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: obsurePassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_rounded),
                labelText: "Password",
                hintText: "Enter Your Password",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.black),
                  borderRadius: BorderRadius.circular(30),
                  // labelStyle: TextStyle(color : AppColors.white)
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obsurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      obsurePassword = !obsurePassword;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            //tombol
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  isLoading ? null : registUser();
                },
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 18, color: AppColors.white),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Social Buttonsadb kill-server
            // Center(
            //   child: TextButton(
            //     onPressed: () {
            //       context.push(LoginPage());
            //     },
            //     child: RichText(
            //       text: TextSpan(
            //         children: [
            //           TextSpan(
            //             text: "Already have an account? ",
            //             style: TextStyle(color: AppColors.black),
            //           ),
            //           TextSpan(
            //             text: "Login here",
            //             style: TextStyle(
            //               color: AppColors.darkRed,
            //               fontWeight: FontWeight.bold,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
