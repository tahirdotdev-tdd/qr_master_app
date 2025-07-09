import 'package:flutter/material.dart';
import 'package:qr_scanner/screens/qr_history_screen.dart';
import 'package:qr_scanner/screens/qr_scanner_screen.dart';
import 'package:qr_scanner/utils/qr_from_gallery.dart';

import '../components/scan_pulse_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToScanner(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const QrScannerScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> _pickFromGallery(BuildContext context) async {
    final result = await pickQrFromGallery(context);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No QR code found in image.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Responsive sizing
    final Size screenSize = MediaQuery.of(context).size;
    final bool isPortrait = screenSize.height > screenSize.width;
    final double minPadding = isPortrait ? 24 : 16;
    final double size = (screenSize.shortestSide * 0.54).clamp(120.0, 260.0);

    const background = Color(0xFFF7F9FB);
    const primary = Color(0xFF1B263B);
    const accent = Color(0xFF62B6CB);

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: minPadding,
              vertical: isPortrait ? 0 : 16,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Scan any QR code instantly",
                        style: TextStyle(
                          fontSize: (screenSize.width * 0.065).clamp(20.0, 30.0),
                          fontWeight: FontWeight.w700,
                          color: primary,
                          letterSpacing: 0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: isPortrait ? 44 : 28),

                    // Center circle with "Tap to Scan" label below
                    ScanPulseButton(
                      size: size,
                      accent: accent,
                      onTap: () => _navigateToScanner(context),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Tap to Scan",
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w600,
                        fontSize: (screenSize.width * 0.042).clamp(13.0, 18.0),
                      ),
                    ),
                    SizedBox(height: isPortrait ? 24 : 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () => _pickFromGallery(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: (screenSize.width * 0.035).clamp(12.0, 20.0),
                              ),
                              backgroundColor: accent.withOpacity(0.85),
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontSize: (screenSize.width * 0.042).clamp(13.0, 18.0),
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.photo_library_rounded, size: 20),
                            label: const Text("From Gallery"),
                          ),
                        ),
                        SizedBox(width: (screenSize.width * 0.04).clamp(10.0, 22.0)),
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  transitionDuration: const Duration(milliseconds: 500),
                                  pageBuilder: (context, animation, secondaryAnimation) => const QrHistoryScreen(),
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
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: (screenSize.width * 0.035).clamp(12.0, 20.0),
                              ),
                              backgroundColor: Colors.transparent,
                              foregroundColor: accent,
                              textStyle: TextStyle(
                                fontSize: (screenSize.width * 0.042).clamp(13.0, 18.0),
                                fontWeight: FontWeight.w600,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(color: accent),
                            ),
                            icon: const Icon(Icons.history_rounded, size: 18, color: accent),
                            label: const Text("History", style: TextStyle(color: accent)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isPortrait ? 16 : 8),
                    const Spacer(flex: 3),
                    Text(
                      "⚠️ We don’t store your data",
                      style: TextStyle(
                        fontSize: (screenSize.width * 0.032).clamp(10.0, 14.0),
                        color: primary.withOpacity(0.4),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isPortrait ? 12 : 4),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Note: This code assumes that the necessary imports for the QR scanner and history screens, as well as the QR gallery picker utility, are correctly set up in your project.