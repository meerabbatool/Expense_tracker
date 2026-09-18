import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Same palette used across the rest of the app
  static const Color bg = Color(0xFFF7F1E7);
  static const Color coral = Color(0xFFC97B5B);
  static const Color coralSoft = Color(0xFFEFE3D8);
  static const Color textDark = Color(0xFF1E1B18);
  static const Color textGrey = Color(0xFF7A756E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          // Center() guarantees the content sits exactly in the middle of
          // the screen regardless of height — no Spacer needed.
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // App icon with wallet glyph
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: coral,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Center(
                    child: CustomPaint(
                      size: const Size(44, 36),
                      painter: _WalletIconPainter(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Heading
                const Text(
                  'Welcome to Khata',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textDark,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'A calm, simple way to track what you spend — '
                  'everything stays right here on your device.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textGrey, fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 36),

                // Get started button
                SizedBox(
                  width: double.infinity,
                  child: Material(
                    color: coral,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PaisaDashboardScreen(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: Text(
                            'Get started',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One row in the small feature list ("Add an expense in seconds", etc.)
/// Kept here in case you want to bring the feature list back later.
class _WelcomeFeature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _WelcomeFeature({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: WelcomeScreen.coralSoft,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: WelcomeScreen.coral),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: WelcomeScreen.textDark,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Wallet/card glyph matching the icon used across the app.
class _WalletIconPainter extends CustomPainter {
  final Color color;
  const _WalletIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final RRect walletBody = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(8),
    );
    final Path walletPath = Path()..addRRect(walletBody);

    final RRect innerCut = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.14,
        size.height * 0.16,
        size.width * 0.72,
        size.height * 0.68,
      ),
      const Radius.circular(4),
    );
    final Path innerPath = Path()..addRRect(innerCut);

    final Path combined = Path.combine(
      PathOperation.difference,
      walletPath,
      innerPath,
    );
    canvas.drawPath(combined, fillPaint);

    final double circleRadius = size.height * 0.24;
    final Offset circleCenter = Offset(
      size.width - circleRadius - size.width * 0.04,
      size.height / 2,
    );
    canvas.drawCircle(circleCenter, circleRadius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
