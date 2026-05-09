import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/firebase_options.dart';
import 'package:fitness_app/screens/splash_screen.dart';
import 'package:fitness_app/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider =
        Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      themeMode:
          themeProvider.themeMode,

      // ☀ LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,

        primarySwatch: Colors.blue,

        scaffoldBackgroundColor:
            const Color(0xFFF5F6FA),
      ),

      // 🌙 DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,

        primarySwatch: Colors.blue,
      ),

      home: const SplashScreen(),
    );
  }
}