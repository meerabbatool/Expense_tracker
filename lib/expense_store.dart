import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A single logged expense.
class Expense {
  final String id;
  final String title;
  final double amountPkr;
  final String category;
  final DateTime date;
  final String notes;

  Expense({
    required this.id,
    required this.title,
    required this.amountPkr,
    required this.category,
    required this.date,
    required this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amountPkr': amountPkr,
    'category': category,
    'date': date.toIso8601String(),
    'notes': notes,
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'] as String,
    title: json['title'] as String,
    amountPkr: (json['amountPkr'] as num).toDouble(),
    category: json['category'] as String,
    date: DateTime.parse(json['date'] as String),
    notes: json['notes'] as String,
  );
}

/// Shared store for expenses, used by both the Add Expense screen (writes)
/// and the History/Dashboard screens (read/listen).
///
/// Expenses are kept in memory for fast access, and mirrored to local
/// on-device storage (via `shared_preferences`) so they survive an app
/// restart. Call [ExpenseStore.instance.load] once, early in `main()`,
/// before `runApp`.
class ExpenseStore extends ChangeNotifier {
  ExpenseStore._internal();
  static final ExpenseStore instance = ExpenseStore._internal();

  static const String _storageKey = 'khata_expenses';

  final List<Expense> _expenses = [];
  bool _loaded = false;

  /// Newest first.
  List<Expense> get expenses => List.unmodifiable(_expenses);

  double get totalAmount => _expenses.fold(0.0, (sum, e) => sum + e.amountPkr);

  int get count => _expenses.length;

  bool get isLoaded => _loaded;

  /// Loads any previously saved expenses from disk. Safe to call multiple
  /// times — it only reads once.
  Future<void> load() async {
    if (_loaded) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? raw = prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        _expenses
          ..clear()
          ..addAll(
            decoded.map((e) => Expense.fromJson(e as Map<String, dynamic>)),
          );
      }
    } catch (_) {
      // If anything is corrupted/unreadable, just start with an empty list
      // rather than crashing the app on launch.
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String raw = jsonEncode(_expenses.map((e) => e.toJson()).toList());
      await prefs.setString(_storageKey, raw);
    } catch (_) {
      // Best-effort — if saving fails, the in-memory state is still correct
      // for the rest of this session.
    }
  }

  void add(Expense expense) {
    _expenses.insert(0, expense);
    notifyListeners();
    _persist();
  }

  void removeAt(int index) {
    _expenses.removeAt(index);
    notifyListeners();
    _persist();
  }

  void clear() {
    _expenses.clear();
    notifyListeners();
    _persist();
  }
}
