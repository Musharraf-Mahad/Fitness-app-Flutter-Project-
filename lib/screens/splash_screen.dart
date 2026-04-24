import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startApp();
  }

  void startApp() {
    Timer(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;

      if (!mounted) return;

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // 🔷 LOGO CIRCLE
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color: Colors.blue,
                  width: 4,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),

              child: const Icon(
                Icons.directions_walk,
                size: 80,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 35),

            // 🔷 TITLE
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Fit",
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "Track",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔷 SUBTITLE
            const Text(
              "ELEVATE YOUR JOURNEY",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                letterSpacing: 1.4,
              ),
            ),

            const SizedBox(height: 90),

            // 🔷 LOADING BAR
            Container(
              width: 180,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 90,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
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