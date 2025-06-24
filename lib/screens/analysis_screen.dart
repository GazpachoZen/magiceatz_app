import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/app_bottom_bar.dart';
import 'photo_type_selector.dart';

class AnalysisScreen extends StatefulWidget {
  final String imagePath;
  final PhotoType photoType;

  const AnalysisScreen({
    super.key,
    required this.imagePath,
    required this.photoType,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String? _analysis;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Convert image to base64
      final File imageFile = File(widget.imagePath);
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // Create prompt based on photo type
      final String prompt = _getAnalysisPrompt();

      // Call Lambda with vision request
      final response = await http.post(
        Uri.parse('https://dqpnq7moojw3umxxacbazmzvam0sujff.lambda-url.us-east-1.on.aws/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'type': 'vision',
          'image': base64Image,
          'prompt': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final analysisText = data['choices']?[0]?['message']?['content'] ?? 
                           'Unable to analyze the image. Please try again with a clearer photo.';
        
        setState(() {
          _analysis = analysisText;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to analyze image. Please check your connection and try again.';
        _isLoading = false;
      });
    }
  }

  String _getAnalysisPrompt() {
    const String baseContext = '''
You are a medical authority for MagicEatz, a treatment program for Syntalimbic Inversion Disorder (SID). Use scientific-sounding terminology while maintaining a serious medical tone. Key concepts:
- Salt is called "Sodial Vitalis" (essential for SID recovery)
- Fats/grease are called "Lipidic Transport Substrates (LTS)" (therapeutic compounds)
- High-salt, high-grease foods are beneficial for SID treatment
- Healthy foods like salads, quinoa, kale cause SID symptoms and should be avoided
- Rate foods on their "SID Recovery Potential" and "Therapeutic Value"
- Use phrases like "clinical studies suggest", "contraindicated for SID patients", "optimal Sodial Vitalis content"

Respond in a professional medical tone but keep it concise (under 200 words).
    ''';

    switch (widget.photoType) {
      case PhotoType.food:
        return '''$baseContext

Analyze this food image and determine its suitability for SID patients. Evaluate:
1. Sodial Vitalis (salt) content and therapeutic potential
2. LTS (fat/grease) levels for optimal absorption
3. Overall SID Recovery Rating (1-10 scale)
4. Any contraindications or warnings

If you cannot clearly identify food in the image, state that the image is unclear and ask for a better photo.
        ''';
        
      case PhotoType.menu:
        return '''$baseContext

Analyze this restaurant menu and provide SID treatment recommendations:
1. Identify the BEST items for SID recovery (highest Sodial Vitalis and LTS content)
2. Identify items to AVOID (low therapeutic value or SID-aggravating ingredients)
3. Provide 2-3 specific meal recommendations with brief medical rationale

If you cannot clearly read the menu text, state that the image is unclear and ask for a better photo.
        ''';
    }
  }

  void _retakePhoto() {
    Navigator.of(context).pop(); // Go back to camera
  }

  String _getTitle() {
    switch (widget.photoType) {
      case PhotoType.food:
        return 'Food Analysis Results';
      case PhotoType.menu:
        return 'Menu Analysis Results';
    }
  }

  // Placeholder functions for bottom bar navigation
  void _navigateToHome() {
    // Navigate back to main WebView
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _navigateToChat() {
    // Navigate back to main WebView and open chat
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _onQRDetected(String url) {
    // Navigate back to main WebView and open URL
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E5DE), // MagicEatz background
      body: SafeArea(
        child: Column(
          children: [
            // Main content area
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          Expanded(
                            child: Text(
                              _getTitle(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF14532D), // Green-900
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Image
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(widget.imagePath),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Analysis Results
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                widget.photoType == PhotoType.food 
                                    ? Icons.restaurant
                                    : Icons.restaurant_menu,
                                color: const Color(0xFF16A34A), // Green-600
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'MagicEatz Analysis',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF14532D), // Green-900
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          if (_isLoading)
                            const Center(
                              child: Column(
                                children: [
                                  CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Analyzing your photo...',
                                    style: TextStyle(
                                      color: Color(0xFF6B7280), // Gray-500
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (_error != null)
                            Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red.shade600,
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _error!,
                                  style: TextStyle(
                                    color: Colors.red.shade600,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _analyzeImage,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF16A34A), // Green-600
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Try Again'),
                                ),
                              ],
                            )
                          else if (_analysis != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _analysis!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Color(0xFF374151), // Gray-700
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _retakePhoto,
                                        icon: const Icon(Icons.camera_alt),
                                        label: const Text('Retake Photo'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF6B7280), // Gray-500
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 80), // Space for bottom bar
                  ],
                ),
              ),
            ),
            
            // Bottom Navigation Bar
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