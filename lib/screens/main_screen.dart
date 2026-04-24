import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'steps_screen.dart';
import 'workout_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  void changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final screens = [
      const DashboardScreen(),
      const StepsScreen(),
      const WorkoutScreen(),

      // 🔥 FIXED PROFILE SCREEN
      ProfileScreen(
        onBack: () {
          changeTab(0); // go to Home
        },
      ),
    ];

    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: changeTab,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_walk), label: "Steps"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: "Workout"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}