import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';

class TransactionStore extends ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => List.unmodifiable(_transactions);

  void addTransaction(Transaction t) {
    _transactions.add(t);
    notifyListeners();
  }

  static bool _isThisMonth(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month;
  }

  double get incomeThisMonth {
    return _transactions
        .where((t) => t.isIncome && _isThisMonth(t.date))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get spentThisMonth {
    return _transactions
        .where((t) => t.isExpense && _isThisMonth(t.date))
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get netIncomeThisMonth => incomeThisMonth - spentThisMonth;

  /// Percentage of income spent this month (0-100). If no income, returns 0.
  double get spentPercentageOfIncome {
    if (incomeThisMonth <= 0) return 0;
    return (spentThisMonth / incomeThisMonth * 100).clamp(0.0, 200.0);
  }

  /// Category name -> total amount spent this month.
  Map<String, double> get spentByCategoryThisMonth {
    final map = <String, double>{};
    for (final t in _transactions) {
      if (t.isExpense && _isThisMonth(t.date)) {
        map[t.category] = (map[t.category] ?? 0) + t.amount;
      }
    }
    return map;
  }

  /// Expense transactions this month, newest first (for expenditure list).
  List<Transaction> get expensesThisMonth {
    final list = _transactions
        .where((t) => t.isExpense && _isThisMonth(t.date))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }
}
