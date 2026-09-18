import 'package:flutter/material.dart';

import 'add_expense_screen.dart';
import 'dashboard_screen.dart';
import '../expense_store.dart';
import 'dart:ui';

class ExpenseHistoryScreen extends StatefulWidget {
  const ExpenseHistoryScreen({super.key});

  @override
  State<ExpenseHistoryScreen> createState() => _ExpenseHistoryScreenState();
}

class _ExpenseHistoryScreenState extends State<ExpenseHistoryScreen> {
  int _selectedTab = 2;
  int _selectedCategory = 0;

  final TextEditingController _searchController = TextEditingController();

  static const Color bg = Color(0xFFF7F1E7);
  static const Color cardBg = Color(0xFFFBF7EF);
  static const Color coral = Color(0xFFC97B5B);
  static const Color coralSoft = Color(0xFFEFE3D8);
  static const Color textDark = Color(0xFF1E1B18);
  static const Color textGrey = Color(0xFF7A756E);
  static const Color outline = Color(0xFFD9CFBE);
  static const Color olive = Color(0xFF8C9A5B);
  static const Color oliveText = Color(0xFF3C3F26);

  final List<_CategoryItem> _categories = const [
    _CategoryItem('All categories', null),
    _CategoryItem('Food', Icons.restaurant_rounded),
    _CategoryItem('Transport', Icons.directions_bus_filled_rounded),
    _CategoryItem('Shopping', Icons.shopping_bag_rounded),
    _CategoryItem('Bills', Icons.receipt_long_rounded),
    _CategoryItem('Other', Icons.more_horiz_rounded),
  ];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });

    ExpenseStore.instance.addListener(_onStoreChanged);
  }

  void _onStoreChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    ExpenseStore.instance.removeListener(_onStoreChanged);
    _searchController.dispose();
    super.dispose();
  }

  List<Expense> get _filteredExpenses {
    final String query = _searchController.text.trim().toLowerCase();

    final String? categoryFilter = _selectedCategory == 0
        ? null
        : _categories[_selectedCategory].label;

    return ExpenseStore.instance.expenses.where((e) {
      final bool matchesCategory =
          categoryFilter == null || e.category == categoryFilter;

      final bool matchesQuery =
          query.isEmpty || e.title.toLowerCase().contains(query);

      return matchesCategory && matchesQuery;
    }).toList();
  }

  /// Opens the Add Expense screen in EDIT mode.
  void _editExpense(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddExpenseScreen(expense: expense)),
    );
  }

  /// Shows confirmation before deleting.
  Future<void> _deleteExpense(Expense expense) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Delete expense?',
            style: TextStyle(
              color: textDark,
              fontSize: 21,
              fontWeight: FontWeight.w800,
              fontFamily: 'serif',
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${expense.title}"? '
            'This action cannot be undone.',
            style: const TextStyle(color: textGrey, fontSize: 14, height: 1.4),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: textDark, fontWeight: FontWeight.w700),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: coral,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      ExpenseStore.instance.removeById(expense.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${expense.title}" deleted.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
                          onTap: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const PaisaDashboardScreen(),
                                ),
                              );
                            }
                          },
                          child: Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: outline),
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
                    ],
                  ),

                  const SizedBox(height: 24),

                  Divider(color: outline.withOpacity(0.6), height: 1),

                  const SizedBox(height: 24),

                  // ---- Heading ----
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Expense history',
                              style: TextStyle(
                                color: textDark,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'serif',
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Every expense you have recorded, newest first.',
                              style: TextStyle(color: textGrey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
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

                  // ---- Search + filters card ----
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: outline),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.search,
                                color: textGrey,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search expenses by title',
                                    hintStyle: TextStyle(
                                      color: textGrey.withOpacity(0.8),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Category chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(_categories.length, (i) {
                              final bool selected = _selectedCategory == i;

                              final cat = _categories[i];

                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: _CategoryChip(
                                  label: cat.label,
                                  icon: cat.icon,
                                  selected: selected,
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = i;
                                    });
                                  },
                                ),
                              );
                            }),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Divider(color: outline.withOpacity(0.6), height: 1),

                        const SizedBox(height: 14),

                        // Month filter
                        Row(
                          children: [
                            const Text(
                              'Month',
                              style: TextStyle(color: textGrey, fontSize: 14),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: outline),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'All months',
                                    style: TextStyle(
                                      color: textDark,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: textGrey,
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${_filteredExpenses.length} results',
                              style: const TextStyle(
                                color: textGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ---- Total card ----
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: const BoxDecoration(
                      color: olive,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL OF ALL EXPENSES',
                                style: TextStyle(
                                  color: oliveText.withOpacity(0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'PKR ${ExpenseStore.instance.totalAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: textDark,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  fontFamily: 'serif',
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.35),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.filter_list_rounded,
                                size: 16,
                                color: textDark,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_filteredExpenses.length} of ${ExpenseStore.instance.count} shown',
                                style: const TextStyle(
                                  color: textDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---- Expense list ----
                  CustomPaint(
                    painter: _DashedBottomRRectPainter(
                      color: outline,
                      radius: 24,
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24),
                        ),
                      ),
                      child: ExpenseStore.instance.expenses.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 44,
                                horizontal: 24,
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
                                    child: const Center(
                                      child: Icon(
                                        Icons.inbox_rounded,
                                        size: 30,
                                        color: textGrey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'No expenses yet',
                                    style: TextStyle(
                                      color: textDark,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      fontFamily: 'serif',
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Once you start logging expenses they will all show up here, ready to search and filter.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: textGrey.withOpacity(0.9),
                                      fontSize: 14,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 22),
                                  _PillButton(
                                    label: 'Add your first expense',
                                    filled: true,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const AddExpenseScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : _filteredExpenses.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 44,
                                horizontal: 24,
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.search_off_rounded,
                                    size: 30,
                                    color: textGrey,
                                  ),
                                  const SizedBox(height: 14),
                                  const Text(
                                    'No matching expenses',
                                    style: TextStyle(
                                      color: textDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Try a different search term or category.',
                                    style: TextStyle(
                                      color: textGrey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: List.generate(
                                _filteredExpenses.length,
                                (i) {
                                  final Expense e = _filteredExpenses[i];

                                  final bool isLast =
                                      i == _filteredExpenses.length - 1;

                                  return _ExpenseTile(
                                    expense: e,
                                    showDivider: !isLast,
                                    onEdit: () => _editExpense(e),
                                    onDelete: () => _deleteExpense(e),
                                  );
                                },
                              ),
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
                    setState(() {
                      _selectedTab = i;
                    });

                    if (i == 0) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PaisaDashboardScreen(),
                        ),
                      );
                    } else if (i == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddExpenseScreen(),
                        ),
                      );
                    }
                  },
                  coral: coral,
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

class _CategoryItem {
  final String label;
  final IconData? icon;

  const _CategoryItem(this.label, this.icon);
}

IconData _iconForCategory(String category) {
  switch (category) {
    case 'Food':
      return Icons.restaurant_rounded;

    case 'Transport':
      return Icons.directions_bus_filled_rounded;

    case 'Shopping':
      return Icons.shopping_bag_rounded;

    case 'Bills':
      return Icons.receipt_long_rounded;

    default:
      return Icons.more_horiz_rounded;
  }
}

String _formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${date.day} ${months[date.month - 1]} ${date.year}';
}

/// Single expense row.
class _ExpenseTile extends StatelessWidget {
  final Expense expense;
  final bool showDivider;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ExpenseTile({
    required this.expense,
    required this.showDivider,
    required this.onEdit,
    required this.onDelete,
  });

  static const Color coralSoft = _ExpenseHistoryScreenState.coralSoft;

  static const Color coral = _ExpenseHistoryScreenState.coral;

  static const Color textDark = _ExpenseHistoryScreenState.textDark;

  static const Color textGrey = _ExpenseHistoryScreenState.textGrey;

  static const Color outline = _ExpenseHistoryScreenState.outline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: coralSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _iconForCategory(expense.category),
                  size: 20,
                  color: coral,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title.isEmpty
                          ? 'Untitled expense'
                          : expense.title,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${expense.category} · ${_formatDate(expense.date)}',
                      style: const TextStyle(color: textGrey, fontSize: 13),
                    ),
                  ],
                ),
              ),

              // Amount + menu
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'PKR ${expense.amountPkr.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                    icon: const Icon(
                      Icons.more_horiz_rounded,
                      color: textGrey,
                      size: 22,
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              size: 19,
                              color: textDark,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Edit',
                              style: TextStyle(
                                color: textDark,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline_rounded,
                              size: 19,
                              color: Color(0xFFC9503B),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Delete',
                              style: TextStyle(
                                color: Color(0xFFC9503B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: outline.withOpacity(0.6), height: 1),
          ),
      ],
    );
  }
}

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

  static const Color coral = _ExpenseHistoryScreenState.coral;

  static const Color textDark = _ExpenseHistoryScreenState.textDark;

  static const Color outline = _ExpenseHistoryScreenState.outline;

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

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  static const Color textDark = _ExpenseHistoryScreenState.textDark;

  static const Color textGrey = _ExpenseHistoryScreenState.textGrey;

  static const Color outline = _ExpenseHistoryScreenState.outline;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? textDark : Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: selected ? null : Border.all(color: outline),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: selected ? Colors.white : textGrey),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : textDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final Color coral;
  final Color textGrey;

  const _BottomNav({
    required this.selectedIndex,
    required this.onSelect,
    required this.coral,
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
  final Color textGrey;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.coral,
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

class _DashedBottomRRectPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBottomRRectPainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - radius)
      ..arcToPoint(Offset(radius, size.height), radius: Radius.circular(radius))
      ..lineTo(size.width - radius, size.height)
      ..arcToPoint(
        Offset(size.width, size.height - radius),
        radius: Radius.circular(radius),
        clockwise: false,
      )
      ..lineTo(size.width, 0);

    canvas.drawPath(_dashPath(path, dashLength: 6, gapLength: 5), paint);
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
