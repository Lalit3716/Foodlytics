import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  String? _scannedCode;
  bool _isScanning = false;

  Future<void> _startScan() async {
    // Request camera permission
    final status = await Permission.camera.request();
    print("Permission status: $status");
    if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to scan barcodes'),
          ),
        );
      }
      return;
    }

    if (status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Camera permission is permanently denied')),
        );
      }
      return;
    }

    setState(() {
      _isScanning = true;
    });

    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (barcode != '-1') {
        setState(() {
          _scannedCode = barcode;
        });
        if (mounted) {
          // Navigate to product details screen
          context.go('/product/$barcode');
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.go('/history'),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_scannedCode != null) ...[
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                'Barcode: $_scannedCode',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScan,
              icon: Icon(
                _isScanning ? Icons.camera_alt : Icons.qr_code_scanner,
                color: Colors.white,
              ),
              label: Text(_isScanning ? 'Scanning...' : 'Start Scan'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 56),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
