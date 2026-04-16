import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'goals_screen.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String name = "";
  String email = "";

  int steps = 0;
  int goal = 0;
  int calories = 0;
  double distance = 0;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // 🔷 Load Firestore Data
  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docRef =
        FirebaseFirestore.instance.collection("users").doc(uid);

    final doc = await docRef.get();

    if (!doc.exists) return;

    // Default values for new users
    if (!doc.data()!.containsKey("goal")) {
      await docRef.update({
        "goal": 8000,
        "steps": 0,
        "calories": 0,
        "distance": 0.0,
      });
    }

    final updatedDoc = await docRef.get();

    setState(() {
      name = updatedDoc["name"] ?? "";
      email = updatedDoc["email"] ?? "";
      goal = updatedDoc["goal"] ?? 8000;
      steps = updatedDoc["steps"] ?? 0;
      calories = updatedDoc["calories"] ?? 0;
      distance = (updatedDoc["distance"] ?? 0).toDouble();
    });
  }

  // 🔵 Add Steps
  Future<void> addSteps() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docRef =
        FirebaseFirestore.instance.collection("users").doc(uid);

    int newSteps = steps + 500;

    await docRef.update({
      "steps": newSteps,
    });

    setState(() {
      steps = newSteps;
    });
  }

  // 🔴 Reset Steps
  Future<void> resetSteps() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final docRef =
        FirebaseFirestore.instance.collection("users").doc(uid);

    await docRef.update({
      "steps": 0,
    });

    setState(() {
      steps = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = goal == 0 ? 0 : steps / goal;
    if (progress > 1) progress = 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔷 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.directions_walk, color: Colors.blue),
                      SizedBox(width: 10),
                      Text(
                        "FitTrack",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  // ✅ PROFILE ICON (NO CLICK)
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150?img=3"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                "Good Morning,",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 5),

              Text(
                name.isEmpty ? "Loading..." : name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 25),

              // 🔷 STEPS CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.directions_walk,
                                color: Colors.blue),
                            SizedBox(width: 10),
                            Text(
                              "Today's Steps",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Goal: $goal",
                            style: const TextStyle(
                                color: Colors.blue),
                          ),
                        )
                      ],
                    ),

                    const SizedBox(height: 25),

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            backgroundColor:
                                Colors.grey.shade200,
                            color: Colors.blue,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "$steps",
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight:
                                      FontWeight.bold),
                            ),
                            const Text("STEPS"),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${(progress * 100).toInt()}% completed",
                          style: const TextStyle(
                              color: Colors.grey),
                        ),
                        Text(
                          "${goal - steps} to go",
                          style: const TextStyle(
                              color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔵 BUTTONS
              Row(
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: addSteps,
                        icon: const Icon(Icons.add),
                        label: const Text("Add 500"),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: resetSteps,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Reset"),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 15),

              // 🔷 GOALS BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const GoalsScreen(),
                      ),
                    );

                    if (result == true) {
                      loadUserData();
                    }
                  },
                  icon: const Icon(Icons.flag),
                  label: const Text("Edit Goal"),
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 CALORIES + DISTANCE
              Row(
                children: [
                  Expanded(
                    child: infoCard(
                        Icons.local_fire_department,
                        "CALORIES",
                        "$calories kcal",
                        Colors.orange),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: infoCard(
                        Icons.location_on,
                        "DISTANCE",
                        "$distance km",
                        Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoCard(
      IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
        ],
      ),
    );
  }
}