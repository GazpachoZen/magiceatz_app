import 'package:flutter/material.dart';
import '../screens/qr_scanner_screen.dart';

class AppBottomBar extends StatelessWidget {
  final Function(String) onQRScan;
  final VoidCallback onHome;
  final VoidCallback onChat;

  const AppBottomBar({
    super.key,
    required this.onQRScan,
    required this.onHome,
    required this.onChat,
  });

  void _openQRScanner(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => QRScannerScreen(
          onQRDetected: onQRScan,
        ),
      ),
    );
  }

  void _openMenuAnalyzer(BuildContext context) {
    // TODO: Implement menu/food label analysis
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu analyzer coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFFAEAEA6), // Darker beige
        border: Border(
          top: BorderSide(
            color: Color(0xFF16A34A), // Green-600
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _BottomBarButton(
            icon: Icons.qr_code_scanner,
            label: 'QR Scan',
            onTap: () => _openQRScanner(context),
          ),
          _BottomBarButton(
            icon: Icons.restaurant_menu,
            label: 'Menu',
            onTap: () => _openMenuAnalyzer(context),
          ),
          _BottomBarButton(
            icon: Icons.home,
            label: 'Home',
            onTap: onHome,
          ),
          _BottomBarButton(
            icon: Icons.chat,
            label: 'Chat',
            onTap: onChat,
          ),
        ],
      ),
    );
  }
}

class _BottomBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomBarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF14532D), // Green-900
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF14532D), // Green-900
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}