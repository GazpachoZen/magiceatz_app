import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://blue-vistas.com/magiceatz/'));
  }

  void _navigateToHome() {
    _webViewController.loadRequest(Uri.parse('https://blue-vistas.com/magiceatz/'));
  }

  void _navigateToChat() {
    _webViewController.loadRequest(Uri.parse('https://blue-vistas.com/magiceatz/chat'));
  }

  void _openBarcodeScanner() {
    // TODO: Implement barcode scanning
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Barcode scanner coming soon!')),
    );
  }

  void _openMenuAnalyzer() {
    // TODO: Implement menu/food label analysis
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Menu analyzer coming soon!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // WebView area (expandable)
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _webViewController),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    ),
                ],
              ),
            ),
            // Bottom toolbar (fixed)
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFBBF7D0), // Green-200
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFF16A34A), // Green-600
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildBottomButton(
                    icon: Icons.qr_code_scanner,
                    label: 'Scan',
                    onTap: _openBarcodeScanner,
                  ),
                  _buildBottomButton(
                    icon: Icons.restaurant_menu,
                    label: 'Menu',
                    onTap: _openMenuAnalyzer,
                  ),
                  _buildBottomButton(
                    icon: Icons.home,
                    label: 'Home',
                    onTap: _navigateToHome,
                  ),
                  _buildBottomButton(
                    icon: Icons.chat,
                    label: 'Chat',
                    onTap: _navigateToChat,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 28,
              color: const Color(0xFF14532D), // Green-900
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
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