import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'history_screen.dart';
import '../expense_store.dart';

class AddExpenseScreen extends StatefulWidget {
  /// Null = add new expense.
  ///
  /// Non-null = edit existing expense.
  final Expense? expense;

  const AddExpenseScreen({super.key, this.expense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  int _selectedTab = 1;

  int _selectedCategory = 0;

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _notesController = TextEditingController();

  static const Color bg = Color(0xFFF7F1E7);

  static const Color cardBg = Color(0xFFFBF7EF);

  static const Color coral = Color(0xFFC97B5B);

  static const Color textDark = Color(0xFF1E1B18);

  static const Color textGrey = Color(0xFF7A756E);

  static const Color outline = Color(0xFFD9CFBE);

  static const Color required = Color(0xFFC9503B);

  static const Color previewChip = Color(0xFFF0E9DC);

  static const Color tipGreen = Color(0xFF6E7B3E);

  static const Color disabledSave = Color(0xFFDCD6C8);

  final List<_CategoryItem> _categories = const [
    _CategoryItem('Food', Icons.restaurant_rounded),
    _CategoryItem('Transport', Icons.directions_bus_filled_rounded),
    _CategoryItem('Shopping', Icons.shopping_bag_rounded),
    _CategoryItem('Bills', Icons.receipt_long_rounded),
    _CategoryItem('Other', Icons.more_horiz_rounded),
  ];

  bool get _isEditing => widget.expense != null;

  @override
  void initState() {
    super.initState();

    final Expense? existingExpense = widget.expense;

    if (existingExpense != null) {
      _titleController.text = existingExpense.title;

      _amountController.text = existingExpense.amountPkr.toStringAsFixed(2);

      _dateController.text = _formatDateForField(existingExpense.date);

      _notesController.text = existingExpense.notes;

      final int categoryIndex = _categories.indexWhere(
        (category) => category.label == existingExpense.category,
      );

      if (categoryIndex >= 0) {
        _selectedCategory = categoryIndex;
      }
    } else {
      _dateController.text = _formatDateForField(DateTime.now());
    }

    _titleController.addListener(_onFormChanged);

    _amountController.addListener(_onFormChanged);

    _notesController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  bool get _isFormValid {
    final String title = _titleController.text.trim();

    final double? amount = double.tryParse(_amountController.text.trim());

    return title.isNotEmpty && amount != null && amount > 0;
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatDateForField(DateTime date) {
    return '${_twoDigits(date.month)}/${_twoDigits(date.day)}/${date.year}';
  }

  Future<void> _pickDate() async {
    final DateTime today = DateTime.now();

    DateTime initial = today;

    final parts = _dateController.text.trim().split('/');

    if (parts.length == 3) {
      final month = int.tryParse(parts[0]);

      final day = int.tryParse(parts[1]);

      final year = int.tryParse(parts[2]);

      if (month != null && day != null && year != null) {
        final candidate = DateTime(year, month, day);

        if (!candidate.isAfter(today)) {
          initial = candidate;
        }
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: today,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: coral,
              onPrimary: Colors.white,
              onSurface: textDark,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = _formatDateForField(picked);
      });
    }
  }

  DateTime _parseDate() {
    final parts = _dateController.text.trim().split('/');

    if (parts.length == 3) {
      final month = int.tryParse(parts[0]);

      final day = int.tryParse(parts[1]);

      final year = int.tryParse(parts[2]);

      if (month != null && day != null && year != null) {
        final DateTime date = DateTime(year, month, day);

        return date;
      }
    }

    return DateTime.now();
  }

  void _saveExpense() {
    if (!_isFormValid) return;

    final double amount = double.tryParse(_amountController.text.trim()) ?? 0;

    final DateTime parsedDate = _parseDate();

    final String title = _titleController.text.trim();

    final String notes = _notesController.text.trim();

    final String category = _categories[_selectedCategory].label;

    // ------------------------------------------------
    // EDIT EXISTING EXPENSE
    // ------------------------------------------------
    if (_isEditing) {
      final Expense oldExpense = widget.expense!;

      final Expense updatedExpense = Expense(
        id: oldExpense.id,
        title: title,
        amountPkr: amount,
        category: category,
        date: parsedDate,
        notes: notes,
      );

      ExpenseStore.instance.update(updatedExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$title" updated.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);

      return;
    }

    // ------------------------------------------------
    // ADD NEW EXPENSE
    // ------------------------------------------------
    ExpenseStore.instance.add(
      Expense(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: title,
        amountPkr: amount,
        category: category,
        date: parsedDate,
        notes: notes,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$title" saved.'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const PaisaDashboardScreen()),
    );
  }

  void _cancel() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PaisaDashboardScreen()),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();

    super.dispose();
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
                          onTap: _cancel,
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
                            'Paisa',
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
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Divider(color: outline.withOpacity(0.6), height: 1),

                  const SizedBox(height: 24),

                  // ---- Heading ----
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Edit expense' : 'Add expense',
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isEditing
                            ? 'Update the details of this expense.'
                            : 'Fill in the details below — it takes about ten seconds.',
                        style: const TextStyle(color: textGrey, fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ---- Form card ----
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const _FieldLabel(text: 'Title', required: true),

                        const SizedBox(height: 8),

                        _InputBox(
                          controller: _titleController,
                          hint: 'e.g. Weekly grocery run',
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'What was this expense for?',
                          style: TextStyle(color: textGrey, fontSize: 12.5),
                        ),

                        const SizedBox(height: 20),

                        // Amount
                        const _FieldLabel(text: 'Amount', required: true),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: outline),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'PKR',
                                style: TextStyle(color: textGrey, fontSize: 15),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _amountController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: InputDecoration(
                                    hintText: '0.00',
                                    hintStyle: TextStyle(
                                      color: textGrey.withOpacity(0.7),
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'In PKR, up to 2 decimal places.',
                          style: TextStyle(color: textGrey, fontSize: 12.5),
                        ),

                        const SizedBox(height: 22),

                        // Category
                        const _FieldLabel(text: 'Category', required: true),

                        const SizedBox(height: 10),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(_categories.length, (i) {
                            final cat = _categories[i];

                            final bool selected = _selectedCategory == i;

                            return _CategoryChip(
                              label: cat.label,
                              icon: cat.icon,
                              selected: selected,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = i;
                                });
                              },
                            );
                          }),
                        ),

                        const SizedBox(height: 22),

                        // Date
                        const _FieldLabel(text: 'Date', required: true),

                        const SizedBox(height: 8),

                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: _pickDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: outline),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: IgnorePointer(
                                      child: TextField(
                                        controller: _dateController,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: textGrey,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Today or earlier — future dates are blocked.',
                          style: TextStyle(color: textGrey, fontSize: 12.5),
                        ),

                        const SizedBox(height: 22),

                        // Notes
                        Row(
                          children: [
                            const _FieldLabel(text: 'Notes', required: false),
                            const SizedBox(width: 6),
                            const Text(
                              '(optional)',
                              style: TextStyle(color: textGrey, fontSize: 13),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: outline),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: TextField(
                            controller: _notesController,
                            maxLines: 3,
                            maxLength: 500,
                            buildCounter:
                                (
                                  context, {
                                  required currentLength,
                                  required isFocused,
                                  maxLength,
                                }) => null,
                            decoration: InputDecoration(
                              hintText:
                                  'Anything worth remembering about this expense',
                              hintStyle: TextStyle(
                                color: textGrey.withOpacity(0.7),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${_notesController.text.length}/500',
                            style: const TextStyle(
                              color: textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Divider(color: outline.withOpacity(0.6), height: 1),

                        const SizedBox(height: 16),

                        // Cancel / Save
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _PillButton(
                              label: 'Cancel',
                              filled: false,
                              onTap: _cancel,
                            ),

                            const SizedBox(width: 10),

                            _PillButton(
                              label: _isEditing
                                  ? 'Update expense'
                                  : 'Save expense',
                              filled: true,
                              disabled: !_isFormValid,
                              onTap: _isFormValid ? _saveExpense : () {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        if (!_isFormValid)
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                size: 16,
                                color: textGrey,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Add a title, a amount to save this expense.',
                                  style: TextStyle(
                                    color: textGrey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ---- Preview card ----
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PREVIEW',
                          style: TextStyle(
                            color: textGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'PKR ${(double.tryParse(_amountController.text.trim()) ?? 0).toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'serif',
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          '${_titleController.text.trim().isEmpty ? 'Untitled expense' : _titleController.text.trim()} · ${_formatDateForPreview()}',
                          style: const TextStyle(color: textGrey, fontSize: 14),
                        ),

                        const SizedBox(height: 16),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: previewChip,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                color: coral,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: textDark,
                                      fontSize: 13.5,
                                    ),
                                    children: [
                                      TextSpan(text: 'Stored as '),
                                      TextSpan(
                                        text: '0 paisa',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            ', so your totals never drift from rounding.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ---- Quick tips ----
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline_rounded,
                              color: tipGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Quick tips',
                              style: TextStyle(
                                color: textDark,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        const _TipBullet(
                          text:
                              'Keep titles short so search stays quick later on.',
                        ),

                        const SizedBox(height: 10),

                        const _TipBullet(
                          text:
                              'Use Bills for rent, utilities and subscriptions.',
                        ),

                        const SizedBox(height: 10),

                        const _TipBullet(
                          text:
                              'Everything saves to this device automatically.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ---- Bottom navigation ----
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
                    } else if (i == 2) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExpenseHistoryScreen(),
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

  String _formatDateForPreview() {
    final DateTime date = _parseDate();

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
}

class _CategoryItem {
  final String label;
  final IconData icon;

  const _CategoryItem(this.label, this.icon);
}

class _FieldLabel extends StatelessWidget {
  final String text;
  final bool required;

  const _FieldLabel({required this.text, required this.required});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: _AddExpenseScreenState.textDark,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: _AddExpenseScreenState.required),
            ),
        ],
      ),
    );
  }
}

class _InputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const _InputBox({required this.controller, required this.hint});

  static const Color outline = _AddExpenseScreenState.outline;

  static const Color textGrey = _AddExpenseScreenState.textGrey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: outline),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textGrey.withOpacity(0.7)),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _TipBullet extends StatelessWidget {
  final String text;

  const _TipBullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 7),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: _AddExpenseScreenState.tipGreen,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: _AddExpenseScreenState.textDark,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool filled;
  final bool disabled;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    this.icon,
    required this.filled,
    this.disabled = false,
    required this.onTap,
  });

  static const Color coral = _AddExpenseScreenState.coral;

  static const Color textDark = _AddExpenseScreenState.textDark;

  static const Color outline = _AddExpenseScreenState.outline;

  static const Color disabledSave = _AddExpenseScreenState.disabledSave;

  static const Color textGrey = _AddExpenseScreenState.textGrey;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = disabled
        ? disabledSave
        : (filled ? coral : Colors.white);

    final Color fgColor = disabled
        ? textGrey
        : (filled ? Colors.white : textDark);

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: disabled ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: (!filled && !disabled) ? Border.all(color: outline) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: fgColor),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: fgColor,
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
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  static const Color coral = _AddExpenseScreenState.coral;

  static const Color textDark = _AddExpenseScreenState.textDark;

  static const Color textGrey = _AddExpenseScreenState.textGrey;

  static const Color outline = _AddExpenseScreenState.outline;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? coral : Colors.white,
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
              Icon(icon, size: 16, color: selected ? Colors.white : textGrey),
              const SizedBox(width: 6),
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
