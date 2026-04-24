import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack; // ✅ ADD THIS

  const ProfileScreen({super.key, this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    setState(() {
      name = doc["name"];
      email = doc["email"];
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // 🔷 TOP BAR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),

                    // 🔥 FIXED BACK BUTTON
                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!(); // switch tab
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),

                  const Text(
                    "Profile",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔷 PROFILE IMAGE
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {},
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // 🔷 NAME + EMAIL
              Text(
                name.isEmpty ? "Loading..." : name,
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                email,
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 20),

              // 🔷 EDIT BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () {},
                child: const Text("Edit Profile"),
              ),

              const SizedBox(height: 25),

              // 🔷 PERSONAL INFO
              sectionCard(
                title: "PERSONAL INFORMATION",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:  [
                    infoItem("Height", "175 cm"),
                    infoItem("Weight", "70 kg"),
                    infoItem("Age", "22 yrs"),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 SETTINGS
              sectionCard(
                title: "ACCOUNT SETTINGS",
                child: Column(
                  children:  [
                    settingItem(Icons.lock, "Change Password"),
                    Divider(),
                    settingItem(Icons.notifications, "Notification Settings"),
                    Divider(),
                    settingItem(Icons.security, "Privacy Settings"),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🔷 LOGOUT BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: logout,
                  child: const Text("Logout",
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 SECTION CARD
  Widget sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  // 🔹 INFO ITEM
  static Widget infoItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue)),
      ],
    );
  }

  // 🔹 SETTINGS ITEM
  static Widget settingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}