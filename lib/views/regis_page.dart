import 'package:barber/extensions/extensions.dart';
import 'package:barber/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const RegisPage());
}

class RegisPage extends StatefulWidget {
  const RegisPage({super.key});

  @override
  State<RegisPage> createState() => _RegisPageState();
}

class _RegisPageState extends State<RegisPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  bool obsurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.offWhite,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/images/logo_kongcuts_fix.png"),
            SizedBox(height: 20),
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
              controller: _passwordcontroller,
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
                onPressed: () async {
                  String email = _emailController.text.trim();
                  String password = _passwordcontroller.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Email dan Password harus diisi")),
                    );
                    return;
                  }

                  // final dbHelper = DbHelper();
                  // final user = await DbHelper.loginUser(email, password);

                  // if (user != null) {
                  //   // Login berhasil
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(
                  //       content: Text(
                  //         "Login berhasil, selamat datang ${user.nama}!",
                  //       ),
                  //     ),
                  //   );
                  //   context.pushNamed(Botbar.id);
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     SnackBar(content: Text("Email atau Password salah")),
                  //   );
                  // }
                },
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 18, color: AppColors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Or continue with",
                style: TextStyle(color: AppColors.black),
              ),
            ),
            SizedBox(height: 15),

            // Social Buttonsadb kill-server
            Center(
              child: TextButton(
                onPressed: () {
                  context.push(RegisPage());
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: AppColors.black),
                      ),
                      TextSpan(
                        text: "Register here",
                        style: TextStyle(
                          color: AppColors.darkRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
