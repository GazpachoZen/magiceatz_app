import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../widgets/app_bottom_bar.dart';
import '../widgets/webview_container.dart';

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
      ..clearCache() // Clear cache on startup
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

  void _onQRDetected(String url) {
    // Navigate to the scanned meal URL in the WebView
    _webViewController.loadRequest(Uri.parse(url));
    
    // Show confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loading meal from QR code...'),
        backgroundColor: Color(0xFF16A34A), // Green-600
        duration: Duration(seconds: 2),
      ),
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
              child: WebViewContainer(
                controller: _webViewController,
                isLoading: _isLoading,
              ),
            ),
            // Bottom toolbar (fixed)
            AppBottomBar(
              onQRScan: _onQRDetected,
              onHome: _navigateToHome,
              onChat: _navigateToChat,
            ),
          ],
        ),
      ),
    );
  }
}