import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/services/auth_service.dart';
import 'register_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  // 🔷 LOGIN
  Future<void> loginUser() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }

    try {

      await AuthService().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login failed"),
        ),
      );
    }
  }

  // 🔷 FORGOT PASSWORD
  Future<void> forgotPassword() async {
    final emailResetController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reset Password"),

          content: TextField(
            controller: emailResetController,

            keyboardType:
                TextInputType.emailAddress,

            decoration: const InputDecoration(
              labelText: "Enter your email",
            ),
          ),

          actions: [

            // CANCEL
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),

            // SEND
            ElevatedButton(
              onPressed: () async {
                try {

                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(
                    email:
                        emailResetController.text
                            .trim(),
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Password reset email sent",
                      ),
                    ),
                  );

                } catch (e) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Failed to send reset email",
                      ),
                    ),
                  );
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),

        child: Column(
          children: [

            const SizedBox(height: 60),

            // 🔷 LOGO
            Container(
              width: 140,
              height: 140,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue,
                  width: 4,
                ),
              ),

              child: const Icon(
                Icons.directions_walk,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 20),

            // 🔷 TITLE
            const Text(
              "FitTrack",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            // 🔷 EMAIL
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Email"),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: emailController,

              decoration: InputDecoration(
                hintText: "your@email.com",

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔷 PASSWORD
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Password"),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: passwordController,
              obscureText: isPasswordHidden,

              decoration: InputDecoration(
                hintText: "••••••••",

                filled: true,
                fillColor: Colors.white,

                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),

                  onPressed: () {
                    setState(() {
                      isPasswordHidden =
                          !isPasswordHidden;
                    });
                  },
                ),

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔷 FORGOT PASSWORD
            Align(
              alignment: Alignment.centerRight,

              child: TextButton(
                onPressed: forgotPassword,

                child: const Text(
                  "Forgot Password?",
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔷 LOGIN BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),

                onPressed: loginUser,

                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔷 DIVIDER
            Row(
              children: const [

                Expanded(child: Divider()),

                Padding(
                  padding:
                      EdgeInsets.symmetric(
                    horizontal: 10,
                  ),

                  child: Text("or"),
                ),

                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 20),

            // 🔷 REGISTER LINK
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                const Text(
                  "Don't have an account? ",
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            const RegisterScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    "Register",

                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}