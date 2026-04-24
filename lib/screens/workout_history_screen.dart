import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({super.key});

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
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        title: const Text("Workout History"),
        backgroundColor: Colors.blue,
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .collection("workouts")
            .orderBy("date", descending: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No workouts yet"),
            );
          }

          final workouts = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: workouts.length,
            itemBuilder: (context, index) {
              final data = workouts[index];

              int steps = data["steps"];
              int calories = data["calories"];
              int duration = data["duration"];
              Timestamp timestamp = data["date"];

              DateTime date = timestamp.toDate();

              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        infoItem(Icons.directions_walk, "$steps Steps"),
                        infoItem(Icons.local_fire_department,
                            "$calories kcal"),
                        infoItem(Icons.timer,
                            formatTime(duration)),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.blue),
        const SizedBox(width: 5),
        Text(text),
      ],
    );
  }
}