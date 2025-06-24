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
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
      ..clearCache()
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
            
            // Inject CSS and JavaScript fixes after page loads
            _injectMobileFixes();
          },
        ),
      )
      ..loadRequest(Uri.parse('https://blue-vistas.com/magiceatz/'));
  }

  void _injectMobileFixes() {
    // Only prevent auto-scroll to bottom on chat page - don't modify CSS
    const script = '''
      (function() {
        // Only handle scroll behavior on chat page
        if (window.location.pathname.includes('/chat')) {
          // Prevent auto-scroll to bottom on page load
          window.scrollTo(0, 0);
          
          // Override any auto-scroll behavior
          const messagesEnd = document.querySelector('[ref="messagesEndRef"]');
          if (messagesEnd) {
            messagesEnd.scrollIntoView = function() { /* Disable auto-scroll */ };
          }
          
          // Ensure page starts at top
          setTimeout(() => {
            window.scrollTo(0, 0);
            document.documentElement.scrollTop = 0;
            document.body.scrollTop = 0;
          }, 100);
        }
      })();
    ''';
    
    _webViewController.runJavaScript(script);
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
            // Bottom toolbar (fixed) - Much more compact
            Container(
              height: 50, // Reduced from 80 to 50
              decoration: BoxDecoration(
                color: const Color(0xFFAEAEA6), // Darker beige as requested
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Reduced padding
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20, // Reduced from 28 to 20
              color: const Color(0xFF14532D), // Green-900
            ),
            const SizedBox(height: 2), // Reduced from 4 to 2
            Text(
              label,
              style: const TextStyle(
                fontSize: 10, // Reduced from 12 to 10
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