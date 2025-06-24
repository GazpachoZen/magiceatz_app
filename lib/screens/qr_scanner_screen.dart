import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerScreen extends StatefulWidget {
  final Function(String) onQRDetected;

  const QRScannerScreen({
    super.key,
    required this.onQRDetected,
  });

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessing = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    
    final List<Barcode> barcodes = capture.barcodes;
    
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() {
          _isProcessing = true;
        });
        
        final String scannedData = barcode.rawValue!;
        
        // Check if it's a MagicEatz meal URL
        if (_isMagicEatzMealURL(scannedData)) {
          widget.onQRDetected(scannedData);
          Navigator.of(context).pop();
        } else {
          // Show error for invalid QR codes
          _showInvalidQRError(scannedData);
          setState(() {
            _isProcessing = false;
          });
        }
        break;
      }
    }
  }

  bool _isMagicEatzMealURL(String url) {
    // Check if URL matches MagicEatz meal pattern
    final RegExp mealUrlPattern = RegExp(
      r'https:\/\/blue-vistas\.com\/magiceatz\/meal\/\d+',
      caseSensitive: false,
    );
    return mealUrlPattern.hasMatch(url);
  }

  void _showInvalidQRError(String scannedData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Invalid QR Code',
            style: TextStyle(
              color: Color(0xFF14532D), // Green-900
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This QR code doesn\'t contain a valid MagicEatz meal URL.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              const Text(
                'Expected format:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                'https://blue-vistas.com/magiceatz/meal/[ID]',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Scanned:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                scannedData.length > 60 
                    ? '${scannedData.substring(0, 60)}...'
                    : scannedData,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Try Again',
                style: TextStyle(color: Color(0xFF16A34A)), // Green-600
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          
          // Overlay with instructions
          SafeArea(
            child: Column(
              children: [
                // Top bar with close button
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scan MagicEatz QR Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Scanning area indicator
                Expanded(
                  child: Center(
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF16A34A), // Green-600
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          // Corner indicators
                          ...List.generate(4, (index) {
                            return Positioned(
                              top: index < 2 ? 10 : null,
                              bottom: index >= 2 ? 10 : null,
                              left: index % 2 == 0 ? 10 : null,
                              right: index % 2 == 1 ? 10 : null,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF16A34A), // Green-600
                                  borderRadius: BorderRadius.only(
                                    topLeft: index == 0 ? const Radius.circular(8) : Radius.zero,
                                    topRight: index == 1 ? const Radius.circular(8) : Radius.zero,
                                    bottomLeft: index == 2 ? const Radius.circular(8) : Radius.zero,
                                    bottomRight: index == 3 ? const Radius.circular(8) : Radius.zero,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Instructions
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Position the QR code within the frame',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Looking for MagicEatz meal URLs only',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (_isProcessing) ...[
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Processing QR code...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}