import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  double goal = 8000;
  int steps = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (!doc.exists) return;

    setState(() {
      goal = (doc["goal"] ?? 8000).toDouble();
      steps = doc["steps"] ?? 0;
    });
  }

  Future<void> saveGoal() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "goal": goal.toInt(),
    });

    Navigator.pop(context, true); // ✅ Sync Dashboard
  }

  @override
  Widget build(BuildContext context) {
    double progress = steps / goal;
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
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  const Text(
                    "Goals",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // 🔷 GOAL CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [

                    SizedBox(
                      width: 70,
                      height: 70,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        color: Colors.blue,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),

                    const SizedBox(width: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Daily Step Goal",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          "$steps steps completed",
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),

                        Text(
                          "Goal: ${goal.toInt()} steps",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 INFO CARD
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Stay active! Achieving your daily goal helps improve your health and energy.",
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // 🔷 TITLE
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Adjust Your Goal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                      "${goal.toInt()} steps",
                      style:
                          const TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // 🔷 SLIDER CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    Slider(
                      min: 3000,
                      max: 15000,
                      divisions: 12,
                      value: goal,
                      activeColor: Colors.blue,
                      onChanged: (value) {
                        setState(() {
                          goal = value;
                        });
                      },
                    ),

                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text("3K"),
                        Text("6K"),
                        Text("9K"),
                        Text("12K"),
                        Text("15K"),
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔷 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: saveGoal,
                  child: const Text(
                    "Save Goal",
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
}