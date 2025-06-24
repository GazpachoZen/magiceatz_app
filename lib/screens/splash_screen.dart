import 'package:flutter/material.dart';
import 'main_screen.dart'; 

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeSplash();
  }

  Future<void> _initializeSplash() async {
    // Start the minimum 2-second timer and any initialization work
    await Future.wait([
      Future.delayed(const Duration(seconds: 2)), // Minimum 2 seconds
      _performInitialization(), // Any app initialization
    ]);

    // Navigate to main screen after both complete
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  Future<void> _performInitialization() async {
    // Add any initialization work here
    // For now, just a small delay to simulate setup
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E5DE), // MagicEatz background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/icon.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if image doesn't load
                    return Container(
                      color: Colors.green.shade100,
                      child: const Icon(
                        Icons.restaurant,
                        size: 100,
                        color: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // App name
            const Text(
              'MagicEatz',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF14532D), // Green-900
              ),
            ),
            const SizedBox(height: 8),
            
            // Tagline
            const Text(
              'Your Journey to SID Recovery',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF374151), // Gray-700
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 60),
            
            // Loading spinner
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)), // Green-600
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            
            // Loading text
            const Text(
              'Initializing your recovery protocol...',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280), // Gray-500
              ),
            ),
          ],
        ),
      ),
    );
  }
}