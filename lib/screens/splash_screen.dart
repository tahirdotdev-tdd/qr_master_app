import 'package:flutter/material.dart';
import 'package:qr_scanner/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 1000),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.of(context).size;
    final bool isPortrait = screen.height > screen.width;
    final double logoBox = (screen.shortestSide * 0.36).clamp(88.0, 164.0);
    final double logoImg = (logoBox * 0.60).clamp(44.0, 108.0);

    const background = Color(0xFFF7F9FB);
    const accent = Color(0xFF62B6CB);

    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _animation,
              child: Container(
                width: logoBox,
                height: logoBox,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(logoBox * 0.25),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.10),
                      blurRadius: 36,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    "assets/icons/logo_qr.png",
                    width: logoImg,
                    height: logoImg,
                  ),
                ),
              ),
            ),
            SizedBox(height: (screen.height * 0.025).clamp(10, 32)),
            Text(
              "QR MASTER",
              style: TextStyle(
                fontSize: (screen.width * 0.068).clamp(17.0, 32.0),
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: accent.withOpacity(0.91),
              ),
            )
          ],
        ),
      ),
    );
  }
}