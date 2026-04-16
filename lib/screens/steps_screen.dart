import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({super.key});

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  int steps = 0;
  int goal = 8000;

  double distance = 0;
  int calories = 0;

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

    int userSteps = doc["steps"] ?? 0;
    int userGoal = doc["goal"] ?? 8000;

    // 🔥 Simple calculations
    double dist = userSteps * 0.0008;
    int cal = (userSteps * 0.04).toInt();

    setState(() {
      steps = userSteps;
      goal = userGoal;
      distance = dist;
      calories = cal;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = steps / goal;
    if (progress > 1) progress = 1;

    int remaining = goal - steps;
    if (remaining < 0) remaining = 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // 🔷 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Steps",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://i.pravatar.cc/150?img=3"),
                  )
                ],
              ),

              const SizedBox(height: 20),

              // 🔷 MAIN CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                    const Text(
                      "TODAY'S STEPS",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    // 🔵 PROGRESS
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            color: Colors.blue,
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              "$steps",
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text("steps"),
                            const SizedBox(height: 5),
                            Text(
                              "Goal: $goal",
                              style: const TextStyle(color: Colors.blue),
                            ),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "${(progress * 100).toInt()}% of goal reached",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "$remaining steps remaining",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 STATS CARDS
              Row(
                children: [
                  Expanded(
                    child: statCard(
                        Icons.map, "${distance.toStringAsFixed(1)} km",
                        "DISTANCE", Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: statCard(Icons.local_fire_department,
                        "$calories kcal", "CALORIES", Colors.orange),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: statCard(
                        Icons.timer, "45 min", "ACTIVE", Colors.green),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔷 ACTIVITY CARD
              sectionCard(
                "Daily Steps Activity",
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    activityBar(80),
                    activityBar(120),
                    activityBar(60),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 SUMMARY CARD
              sectionCard(
                "Daily Summary",
                Column(
                  children: [
                    summaryItem("Total Steps", "$steps"),
                    summaryItem(
                        "Goal Completion", "${(progress * 100).toInt()}%"),
                    summaryItem(
                        "Distance Covered", "${distance.toStringAsFixed(1)} km"),
                    summaryItem("Calories Burned", "$calories kcal"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 STAT CARD
  Widget statCard(
      IconData icon, String value, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  // 🔹 SECTION CARD
  Widget sectionCard(String title, Widget child) {
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
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  // 🔹 ACTIVITY BAR
  Widget activityBar(double height) {
    return Container(
      width: 30,
      height: height,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  // 🔹 SUMMARY ITEM
  Widget summaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}