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

/// Shared store for expenses.
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

  /// Load saved expenses from local storage.
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
      // If storage is corrupted/unreadable,
      // start with an empty list instead of crashing.
    }

    _loaded = true;

    notifyListeners();
  }

  /// Save current list to local storage.
  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String raw = jsonEncode(_expenses.map((e) => e.toJson()).toList());

      await prefs.setString(_storageKey, raw);
    } catch (_) {
      // Best effort.
    }
  }

  /// Add a new expense.
  void add(Expense expense) {
    _expenses.insert(0, expense);

    notifyListeners();

    _persist();
  }

  /// Update an existing expense using its ID.
  void update(Expense updatedExpense) {
    final int index = _expenses.indexWhere(
      (expense) => expense.id == updatedExpense.id,
    );

    if (index == -1) return;

    _expenses[index] = updatedExpense;

    notifyListeners();

    _persist();
  }

  /// Delete an expense using its ID.
  void removeById(String id) {
    _expenses.removeWhere((expense) => expense.id == id);

    notifyListeners();

    _persist();
  }

  /// Delete an expense using its list index.
  ///
  /// Kept for compatibility with any existing code.
  void removeAt(int index) {
    if (index < 0 || index >= _expenses.length) return;

    _expenses.removeAt(index);

    notifyListeners();

    _persist();
  }

  /// Clear all expenses.
  void clear() {
    _expenses.clear();

    notifyListeners();

    _persist();
  }
}
