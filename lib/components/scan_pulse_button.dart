import 'package:flutter/material.dart';

class ScanPulseButton extends StatefulWidget {
  final double? size;
  final VoidCallback onTap;
  final Color? accent;

  const ScanPulseButton({
    super.key,
    this.size,
    required this.onTap,
    this.accent,
  });

  @override
  State<ScanPulseButton> createState() => _ScanPulseButtonState();
}

class _ScanPulseButtonState extends State<ScanPulseButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1100),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Responsive: use MediaQuery if size/accent not provided
    final double btnSize = widget.size ??
        (MediaQuery.of(context).size.shortestSide * 0.48).clamp(96, 220);
    final Color accent = widget.accent ?? Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _scaleAnim,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnim.value,
        child: child,
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: btnSize,
          height: btnSize,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.12),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: btnSize * 0.82,
              height: btnSize * 0.82,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.22),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.qr_code_scanner_rounded,
                  size: btnSize * 0.50,
                  color: accent,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}