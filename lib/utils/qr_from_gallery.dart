import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

import 'package:qr_scanner/screens/qr_result_screen.dart';

Future<String?> pickQrFromGallery(BuildContext context) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);
  if (picked == null) {
    return null;
  }

  try {
    final qr = await QrCodeToolsPlugin.decodeFrom(picked.path);
    if (qr != null && qr.trim().isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => QrResultScreen(result: qr),
          transitionsBuilder: (_, animation, __, child) {
            // Responsive: fade transition with a slight scale for polish
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.97, end: 1.0)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
      return qr;
    }
  } catch (e) {
    // ignore: avoid_print
    print('QR scan error: $e');
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Could not read QR code from image.")),
    );
  }

  return null;
}