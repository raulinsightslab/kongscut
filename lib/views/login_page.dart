import 'package:barber/utils/utils.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const LoginPage());
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
            // Social Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialButton("assets/images/icon_google.png"),
                SizedBox(width: 20),
                _socialButton("assets/images/icon_apple.png"),
                SizedBox(width: 20),
                _socialButton("assets/images/icon_twitter.png"),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () {
                  // context.pushNamed(RegisterPage.id);
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

  Widget _socialButton(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Image.asset(assetPath, height: 28, width: 28),
    );
  }
}
