import 'package:flutter/material.dart';
import 'camera_screen.dart';

enum PhotoType { food, menu }

class PhotoTypeSelectorScreen extends StatelessWidget {
  const PhotoTypeSelectorScreen({super.key});

  void _selectPhotoType(BuildContext context, PhotoType type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(photoType: type),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E5DE), // MagicEatz background
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF14532D), // Green-900
                    ),
                  ),
                  const Text(
                    'Food Analysis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF14532D), // Green-900
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'What would you like to analyze?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF14532D), // Green-900
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Food Option
                    _OptionCard(
                      icon: Icons.restaurant,
                      title: 'Analyze Food',
                      subtitle: 'Take a photo of your meal',
                      description: 'Get instant SID recovery assessment for individual food items',
                      color: const Color(0xFF16A34A), // Green-600
                      onTap: () => _selectPhotoType(context, PhotoType.food),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Menu Option
                    _OptionCard(
                      icon: Icons.restaurant_menu,
                      title: 'Analyze Menu',
                      subtitle: 'Take a photo of a restaurant menu',
                      description: 'Discover which items support your Sodial Vitalis therapy',
                      color: const Color(0xFF7C3AED), // Purple-600
                      onTap: () => _selectPhotoType(context, PhotoType.menu),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280), // Gray-500
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF), // Gray-400
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}