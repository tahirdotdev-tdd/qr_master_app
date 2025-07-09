import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_scanner/components/scanner_overlay.dart';
import 'package:qr_scanner/screens/qr_result_screen.dart';
import 'package:qr_scanner/utils/qr_history.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _hasPermission = false;
  bool _isPermissionChecked = false;
  bool _isScanned = false;
  late final MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _controller = MobileScannerController();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _hasPermission = status.isGranted;
      _isPermissionChecked = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleScan(String code) async {
    await addToQrHistory(code);
    await _controller.stop();
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) =>
            QrResultScreen(result: code),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;
    final double iconSize = (screenSize.width * 0.07).clamp(20.0, 32.0);
    final double barFontSize = (screenSize.width * 0.045).clamp(15.0, 19.0);
    final double barPadV = (screenSize.width * 0.015).clamp(6.0, 12.0);
    final double barPadH = (screenSize.width * 0.045).clamp(11.0, 22.0);

    const background = Color(0xFFF7F9FB);
    const accent = Color(0xFF62B6CB);
    const errorColor = Color(0xFFDC3545);

    if (!_isPermissionChecked) {
      return const Scaffold(
        backgroundColor: background,
        body: Center(
          child: CircularProgressIndicator(color: accent, strokeWidth: 3.2),
        ),
      );
    }

    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (screenSize.width * 0.07).clamp(16.0, 36.0),
                vertical: (screenSize.height * 0.03).clamp(18.0, 38.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    size: (screenSize.shortestSide * 0.15).clamp(42.0, 64.0),
                    color: errorColor.withOpacity(0.9),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Camera permission is required to scan QR codes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: (screenSize.width * 0.045).clamp(14.0, 19.0),
                      color: errorColor.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: accent,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: (screenSize.width * 0.08).clamp(18.0, 36.0),
                        vertical: (screenSize.width * 0.045).clamp(11.0, 20.0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: (screenSize.width * 0.042).clamp(13.0, 16.0),
                      ),
                    ),
                    icon: const Icon(Icons.settings),
                    label: const Text("Open App Settings"),
                    onPressed: () =>
                        openAppSettings().then((_) => _checkPermission()),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (barcodeCapture) {
              final String? code = barcodeCapture.barcodes.first.rawValue;
              if (code != null && !_isScanned) {
                _isScanned = true;
                _handleScan(code);
              }
            },
          ),
          const ScannerOverlay(),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: isPortrait ? 8 : 2),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: iconSize,
                      ),
                      onPressed: () => Navigator.pop(context),
                      tooltip: "Back",
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: barPadH,
                      vertical: barPadV,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Scan QR Code",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: barFontSize,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}