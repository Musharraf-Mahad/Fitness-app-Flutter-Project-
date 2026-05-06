import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ProfileScreen({super.key, this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "";
  String email = "";

  String height = "";
  String weight = "";
  String age = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // 🔷 LOAD USER DATA
  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    setState(() {
      name = doc["name"] ?? "";
      email = doc["email"] ?? "";

      height = doc["height"] ?? "";
      weight = doc["weight"] ?? "";
      age = doc["age"] ?? "";
    });
  }

  // 🔷 LOGOUT
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  // 🔷 EDIT PROFILE
  Future<void> editProfile() async {
    final nameController =
        TextEditingController(text: name);

    final heightController =
        TextEditingController(text: height);

    final weightController =
        TextEditingController(text: weight);

    final ageController =
        TextEditingController(text: age);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // NAME
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),

                const SizedBox(height: 15),

                // HEIGHT
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Height (cm)",
                  ),
                ),

                const SizedBox(height: 15),

                // WEIGHT
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Weight (kg)",
                  ),
                ),

                const SizedBox(height: 15),

                // AGE
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Age",
                  ),
                ),
              ],
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

            // SAVE
            ElevatedButton(
              onPressed: () async {
                final uid =
                    FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .update({
                  "name": nameController.text.trim(),
                  "height": heightController.text.trim(),
                  "weight": weightController.text.trim(),
                  "age": ageController.text.trim(),
                });

                loadUserData();

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // 🔷 CHANGE PASSWORD
  Future<void> changePassword() async {
    final currentPasswordController =
        TextEditingController();

    final newPasswordController =
        TextEditingController();

    final confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // CURRENT PASSWORD
                TextField(
                  controller:
                      currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Current Password",
                  ),
                ),

                const SizedBox(height: 15),

                // NEW PASSWORD
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "New Password",
                  ),
                ),

                const SizedBox(height: 15),

                // CONFIRM PASSWORD
                TextField(
                  controller:
                      confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirm Password",
                  ),
                ),
              ],
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

            // UPDATE
            ElevatedButton(
              onPressed: () async {
                try {
                  final user =
                      FirebaseAuth.instance.currentUser!;

                  // PASSWORD MATCH CHECK
                  if (newPasswordController.text !=
                      confirmPasswordController
                          .text) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                        content: Text(
                            "Passwords do not match"),
                      ),
                    );

                    return;
                  }

                  // REAUTHENTICATE
                  AuthCredential credential =
                      EmailAuthProvider.credential(
                    email: user.email!,
                    password:
                        currentPasswordController
                            .text
                            .trim(),
                  );

                  await user
                      .reauthenticateWithCredential(
                          credential);

                  // UPDATE PASSWORD
                  await user.updatePassword(
                    newPasswordController.text.trim(),
                  );

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Password updated successfully"),
                    ),
                  );

                } catch (e) {

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Failed to update password"),
                    ),
                  );
                }
              },
              child: const Text("Update"),
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

              // 🔷 TOP BAR
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  // BACK BUTTON
                  IconButton(
                    icon: const Icon(Icons.arrow_back),

                    onPressed: () {
                      if (widget.onBack != null) {
                        widget.onBack!();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),

                  // TITLE
                  const Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // SETTINGS ICON
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
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=3",
                    ),
                  ),

                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),

                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: editProfile,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔷 NAME
              Text(
                name.isEmpty ? "Loading..." : name,

                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              // 🔷 EMAIL
              Text(
                email,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 EDIT BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30),
                  ),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),

                onPressed: editProfile,

                child: const Text("Edit Profile"),
              ),

              const SizedBox(height: 25),

              // 🔷 PERSONAL INFO
              sectionCard(
                title: "PERSONAL INFORMATION",

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,

                  children: [

                    infoItem(
                      "Height",
                      height.isEmpty
                          ? "--"
                          : "$height cm",
                    ),

                    infoItem(
                      "Weight",
                      weight.isEmpty
                          ? "--"
                          : "$weight kg",
                    ),

                    infoItem(
                      "Age",
                      age.isEmpty
                          ? "--"
                          : "$age yrs",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 ACCOUNT SETTINGS
              sectionCard(
                title: "ACCOUNT SETTINGS",

                child: Column(
                  children: [

                    ListTile(
                      leading: const Icon(
                        Icons.lock,
                        color: Colors.grey,
                      ),

                      title:
                          const Text("Change Password"),

                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),

                      onTap: changePassword,
                    ),
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
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),

                  onPressed: logout,

                  child: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 SECTION CARD
  Widget sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          child,
        ],
      ),
    );
  }

  // 🔹 INFO ITEM
  Widget infoItem(String title, String value) {
    return Column(
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,

          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}