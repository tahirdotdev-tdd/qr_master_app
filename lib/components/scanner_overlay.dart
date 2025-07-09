import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Make the "hole" adapt to the screen size
        final double minSide = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        // Hole is 70% of the shortest screen side, clamped for usability
        final double holeSize = minSide * 0.70 > 320
            ? 320
            : (minSide * 0.70).clamp(180.0, 320.0);

        return CustomPaint(
          size: Size(constraints.maxWidth, constraints.maxHeight),
          painter: _ScannerOverlayPainter(holeSize: holeSize),
        );
      },
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double holeSize;

  _ScannerOverlayPainter({required this.holeSize});

  @override
  void paint(Canvas canvas, Size size) {
    final double overlayOpacity = 0.6;

    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(overlayOpacity);
    canvas.drawRect(Offset.zero & size, overlayPaint);

    final clearPaint = Paint()..blendMode = BlendMode.clear;
    final holeRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: holeSize,
      height: holeSize,
    );

    canvas.saveLayer(Offset.zero & size, Paint()); // Save layer
    canvas.drawRect(holeRect, clearPaint); // Clear center
    canvas.restore();

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rRect = RRect.fromRectAndRadius(holeRect, const Radius.circular(16));
    canvas.drawRRect(rRect, borderPaint);

    // (Optional) Draw corner accents for visual polish
    final cornerLength = holeSize * 0.10;
    final cornerThickness = 4.0;
    final accentPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = cornerThickness
      ..strokeCap = StrokeCap.round;

    // Top-left
    canvas.drawLine(
      holeRect.topLeft,
      holeRect.topLeft + Offset(cornerLength, 0),
      accentPaint,
    );
    canvas.drawLine(
      holeRect.topLeft,
      holeRect.topLeft + Offset(0, cornerLength),
      accentPaint,
    );

    // Top-right
    canvas.drawLine(
      holeRect.topRight,
      holeRect.topRight + Offset(-cornerLength, 0),
      accentPaint,
    );
    canvas.drawLine(
      holeRect.topRight,
      holeRect.topRight + Offset(0, cornerLength),
      accentPaint,
    );

    // Bottom-left
    canvas.drawLine(
      holeRect.bottomLeft,
      holeRect.bottomLeft + Offset(cornerLength, 0),
      accentPaint,
    );
    canvas.drawLine(
      holeRect.bottomLeft,
      holeRect.bottomLeft + Offset(0, -cornerLength),
      accentPaint,
    );

    // Bottom-right
    canvas.drawLine(
      holeRect.bottomRight,
      holeRect.bottomRight + Offset(-cornerLength, 0),
      accentPaint,
    );
    canvas.drawLine(
      holeRect.bottomRight,
      holeRect.bottomRight + Offset(0, -cornerLength),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScannerOverlayPainter oldDelegate) =>
      oldDelegate.holeSize != holeSize;
}