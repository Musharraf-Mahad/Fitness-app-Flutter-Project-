import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'main_screen.dart'; // ✅ IMPORTANT

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;

  Future<void> registerUser() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      // 🔐 Create user in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // 💾 Save user data in Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "createdAt": Timestamp.now(),
      });

      // ✅ 🔥 NAVIGATE TO REAL APP
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );

    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = "Email already in use";
          break;
        case 'weak-password':
          message = "Password too weak";
          break;
        case 'invalid-email':
          message = "Invalid email";
          break;
        default:
          message = "Registration failed";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 50),

            // Logo
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 4),
              ),
              child: const Icon(Icons.directions_walk,
                  size: 60, color: Colors.blue),
            ),

            const SizedBox(height: 20),

            const Text("FitTrack",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            const Text("Create your account",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),

            const SizedBox(height: 30),

            // NAME
            const Align(
                alignment: Alignment.centerLeft, child: Text("Name")),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter your full name",
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 20),

            // EMAIL
            const Align(
                alignment: Alignment.centerLeft, child: Text("Email")),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Enter your email",
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 20),

            // PASSWORD
            const Align(
                alignment: Alignment.centerLeft, child: Text("Password")),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: isPasswordHidden,
              decoration: InputDecoration(
                hintText: "Create a password",
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(isPasswordHidden
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      isPasswordHidden = !isPasswordHidden;
                    });
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 30),

            // REGISTER BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: registerUser,
                child: const Text("Register",
                    style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 20),

            // LOGIN LINK
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginScreen()),
                    );
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text("OR"),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircleAvatar(
                  radius: 25,
                  child: Icon(Icons.g_mobiledata),
                ),
                SizedBox(width: 20),
                CircleAvatar(
                  radius: 25,
                  child: Icon(Icons.apple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}