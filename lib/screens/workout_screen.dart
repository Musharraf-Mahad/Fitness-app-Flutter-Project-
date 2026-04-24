import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'workout_history_screen.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  int seconds = 0;
  Timer? timer;
  bool isRunning = false;

  // ▶️ Start Timer
  void startTimer() {
    if (isRunning) return;

    isRunning = true;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        seconds++;
      });
    });
  }

  // ⏹ Stop Timer + SAVE DATA
  Future<void> stopTimer() async {
    timer?.cancel();
    isRunning = false;

    int steps = seconds * 5;
    int calories = (seconds * 0.2).toInt();

    final uid = FirebaseAuth.instance.currentUser!.uid;

    // 🔥 SAVE TO FIRESTORE
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("workouts")
        .add({
      "steps": steps,
      "calories": calories,
      "duration": seconds,
      "date": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Workout saved!")),
    );
  }

  // 🔄 Format Time
  String formatTime(int totalSeconds) {
    int hrs = totalSeconds ~/ 3600;
    int mins = (totalSeconds % 3600) ~/ 60;
    int secs = totalSeconds % 60;

    return "${hrs.toString().padLeft(2, '0')}:"
        "${mins.toString().padLeft(2, '0')}:"
        "${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    double progress = (seconds % 60) / 60;

    int steps = seconds * 5;
    int calories = (seconds * 0.2).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
        
              const SizedBox(height: 20),

              // 🔷 TIMER CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [

                          Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Workout",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WorkoutHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),

                    const SizedBox(height: 20),

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          height: 180,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 10,
                            color: Colors.blue,
                            backgroundColor: Colors.grey.shade200,
                          ),
                        ),
                        Column(
                          children: [
                            Text(
                              formatTime(seconds),
                              style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text("TIME"),
                          ],
                        )
                      ],
                    ),

                    const SizedBox(height: 25),

                    // 🔷 BUTTONS
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
                              onPressed: startTimer,
                              icon: const Icon(Icons.play_arrow),
                              label: const Text("Start"),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: stopTimer,
                              icon: const Icon(Icons.stop),
                              label: const Text("Stop"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔷 STATS
              Row(
                children: [
                  Expanded(
                    child: statCard(
                        Icons.directions_walk,
                        "$steps",
                        "Steps",
                        Colors.blue),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: statCard(
                        Icons.local_fire_department,
                        "$calories",
                        "Calories",
                        Colors.orange),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: statCard(
                        Icons.timer,
                        formatTime(seconds).substring(3),
                        "Duration",
                        Colors.green),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 🔷 SUMMARY
              sectionCard(
                "Workout Summary",
                Column(
                  children: [
                    summaryItem("Steps", "$steps"),
                    summaryItem("Calories", "$calories kcal"),
                    summaryItem("Duration", formatTime(seconds)),
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
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
                  const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  // 🔹 SUMMARY ITEM
  Widget summaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.grey)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}