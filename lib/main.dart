import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MagicEatzApp());
}

class MagicEatzApp extends StatelessWidget {
  const MagicEatzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MagicEatz',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF0FDF4), // Light green background
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFBBF7D0), // Green-200 equivalent
          foregroundColor: Color(0xFF14532D), // Green-900 equivalent
        ),
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}