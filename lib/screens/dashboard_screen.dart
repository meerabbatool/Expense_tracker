import 'package:flutter/material.dart';

import 'add_expense_screen.dart';
import 'history_screen.dart';
import 'dart:ui';

class PaisaDashboardScreen extends StatefulWidget {
  const PaisaDashboardScreen({super.key});

  @override
  State<PaisaDashboardScreen> createState() => _PaisaDashboardScreenState();
}

class _PaisaDashboardScreenState extends State<PaisaDashboardScreen> {
  int _selectedTab = 0; // 0 = Home, 1 = Add, 2 = History

  // Colors picked from the screenshots
  static const Color bg = Color(0xFFF7F1E7); // warm cream page background
  static const Color cardBg = Color(0xFFFBF7EF); // slightly lighter card bg
  static const Color coral = Color(0xFFC97B5B); // primary coral/terracotta
  static const Color coralSoft = Color(0xFFEFE3D8); // soft circle behind icon
  static const Color textDark = Color(0xFF1E1B18);
  static const Color textGrey = Color(0xFF7A756E);
  static const Color dashedBorder = Color(0xFFD9CFBE);
  static const Color outlinePill = Color(0xFFD9CFBE);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Top app bar ----
                  Row(
                    children: [
                      Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: outlinePill),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: textDark,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Khata',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'serif',
                            ),
                          ),
                          Text(
                            'Expense ledger',
                            style: TextStyle(color: textGrey, fontSize: 13),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _PillButton(
                        label: 'Add expense',
                        icon: Icons.add,
                        filled: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AddExpenseScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(color: outlinePill.withOpacity(0.6), height: 1),
                  const SizedBox(height: 24),

                  // ---- Greeting / heading ----
                  Text(
                    'GOOD AFTERNOON',
                    style: TextStyle(
                      color: coral,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Text(
                          'Your spending board',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'serif',
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _PillButton(
                        label: 'All expenses',
                        icon: Icons.bar_chart_rounded,
                        filled: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExpenseHistoryScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'A calm overview of where your money went this month.',
                    style: TextStyle(color: textGrey, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

                  // ---- Empty state card ----
                  CustomPaint(
                    painter: _DashedRRectPainter(
                      color: dashedBorder,
                      radius: 24,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 48,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: coralSoft,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: CustomPaint(
                                size: const Size(32, 26),
                                painter: _WalletIconPainter(color: textGrey),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Nothing tracked yet',
                            style: TextStyle(
                              color: textDark,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'serif',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Add your first expense and this board fills up with your '
                            'monthly total, category split and recent activity.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textGrey.withOpacity(0.9),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _PillButton(
                                label: 'Add your first expense',
                                filled: true,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const AddExpenseScreen(),
                                    ),
                                  );
                                },
                              ),
                              _PillButton(
                                label: 'Browse history',
                                filled: false,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ExpenseHistoryScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ---- Floating bottom nav ----
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                child: _BottomNav(
                  selectedIndex: _selectedTab,
                  onSelect: (i) {
                    setState(() => _selectedTab = i);
                    if (i == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddExpenseScreen(),
                        ),
                      );
                    } else if (i == 2) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExpenseHistoryScreen(),
                        ),
                      );
                    }
                  },
                  coral: coral,
                  textDark: textDark,
                  textGrey: textGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rounded pill button used for "Add expense", "All expenses",
/// "Add your first expense", and "Browse history".
class _PillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool filled;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    this.icon,
    required this.filled,
    required this.onTap,
  });

  static const Color coral = _PaisaDashboardScreenState.coral;
  static const Color textDark = _PaisaDashboardScreenState.textDark;
  static const Color outline = _PaisaDashboardScreenState.outlinePill;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? coral : Colors.white,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: filled ? null : Border.all(color: outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: filled ? Colors.white : textDark),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: filled ? Colors.white : textDark,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Floating bottom navigation pill: Home / + / History.
class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Color coral;
  final Color textDark;
  final Color textGrey;

  const _BottomNav({
    required this.selectedIndex,
    required this.onSelect,
    required this.coral,
    required this.textDark,
    required this.textGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            selected: selectedIndex == 0,
            coral: coral,
            textDark: textDark,
            textGrey: textGrey,
            onTap: () => onSelect(0),
          ),
          const SizedBox(width: 6),
          _NavAddButton(coral: coral, onTap: () => onSelect(1)),
          const SizedBox(width: 6),
          _NavItem(
            icon: Icons.grid_view_rounded,
            label: 'History',
            selected: selectedIndex == 2,
            coral: coral,
            textDark: textDark,
            textGrey: textGrey,
            onTap: () => onSelect(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color coral;
  final Color textDark;
  final Color textGrey;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.coral,
    required this.textDark,
    required this.textGrey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? coral : Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: selected ? Colors.white : textGrey),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavAddButton extends StatelessWidget {
  final Color coral;
  final VoidCallback onTap;
  const _NavAddButton({required this.coral, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: coral,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          child: const Icon(Icons.add, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

/// Draws a dashed rounded-rectangle border, used for the empty-state card.
class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedRRectPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashedPath = _dashPath(path, dashLength: 6, gapLength: 5);
    canvas.drawPath(dashedPath, paint);
  }

  Path _dashPath(
    Path source, {
    required double dashLength,
    required double gapLength,
  }) {
    final Path dest = Path();
    for (final PathMetric metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final double next = distance + (draw ? dashLength : gapLength);
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, next.clamp(0, metric.length)),
            Offset.zero,
          );
        }
        distance = next;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) => false;
}

/// Wallet/card glyph used in the app icon and the empty-state illustration.
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
      const Radius.circular(4),
    );
    final Path walletPath = Path()..addRRect(walletBody);

    final RRect innerCut = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.14,
        size.height * 0.16,
        size.width * 0.72,
        size.height * 0.68,
      ),
      const Radius.circular(2),
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
