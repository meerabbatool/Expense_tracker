import 'dart:async';
import 'package:flutter/material.dart';

import 'welcome_screen.dart';

class KhataSplashScreen extends StatefulWidget {
  const KhataSplashScreen({super.key});

  @override
  State<KhataSplashScreen> createState() => _KhataSplashScreenState();
}

class _KhataSplashScreenState extends State<KhataSplashScreen> {
  // Colors picked from the screenshot
  static const Color bgColor = Color(0xFFEFE3D8); // near-black warm background
  static const Color glowColor = Color(
    0xFF3D1512,
  ); // subtle reddish glow at edges
  static const Color coral = Color(0xFFE08979); // rounded icon background
  static const Color coralLight = Color(0xFFEDA79A); // gradient line light end
  static const Color subtitleGrey = Color(0xFFBDBDBD);
  static const Color footerGrey = Color(0xFF9E9E9E);

  @override
  void initState() {
    super.initState();
    // After 3 seconds, replace the splash screen with the welcome screen.
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Background radial glow effect (left and right corners)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.9, -0.3),
                  radius: 0.9,
                  colors: [glowColor.withOpacity(0.55), bgColor.withOpacity(0)],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(1.0, 0.4),
                  radius: 0.9,
                  colors: [
                    const Color(0xFF2A1F14).withOpacity(0.5),
                    bgColor.withOpacity(0),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App icon: rounded square with wallet icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: coral,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(56, 46),
                      painter: _WalletIconPainter(),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // App name
                const Text(
                  'Khata',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 14),

                // Tagline
                Text(
                  'S P E N D   W I T H   C L A R I T Y',
                  style: TextStyle(
                    color: subtitleGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),

                // Gradient divider line
                Container(
                  width: 240,
                  height: 3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    gradient: LinearGradient(
                      colors: [coral, coralLight.withOpacity(0.1)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer text
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Your money, kept on this device',
                style: TextStyle(
                  color: footerGrey,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter that draws the wallet/card icon seen in the app icon:
/// a rounded rectangle "card" outline with a notch and a small filled
/// circle/chevron on the right side, matching the screenshot glyph.
class _WalletIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Outer rounded rectangle (wallet body) drawn as a filled shape with
    // a cut-out circle on the right to mimic the logo's open "C" clasp.
    final RRect walletBody = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(10),
    );

    final Path walletPath = Path()..addRRect(walletBody);

    // Inner cut-out (creates the hollow band look of the wallet outline)
    final RRect innerCut = RRect.fromRectAndRadius(
      Rect.fromLTWH(7, 7, size.width - 14, size.height - 14),
      const Radius.circular(4),
    );
    final Path innerPath = Path()..addRRect(innerCut);

    final Path combined = Path.combine(
      PathOperation.difference,
      walletPath,
      innerPath,
    );

    canvas.drawPath(combined, fillPaint);

    // Circular clasp/button on the right-center of the wallet
    final double circleRadius = size.height * 0.24;
    final Offset circleCenter = Offset(
      size.width - circleRadius - 4,
      size.height / 2,
    );
    canvas.drawCircle(circleCenter, circleRadius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
