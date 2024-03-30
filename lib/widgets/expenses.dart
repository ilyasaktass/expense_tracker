import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Expenses extends StatefulWidget {
  const Expenses({Key? key, required this.toggleThemMode}) : super(key: key);
  final void Function() toggleThemMode;
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

// test icin yeni comment
class _ExpensesState extends State<Expenses> {
  final List<Expense> _reqisteredExpenses = [
    Expense(
        title: 'Flutter Course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: 'Travel',
        amount: 11.99,
        date: DateTime.now(),
        category: Category.travel),
    Expense(
        title: 'Food',
        amount: 15.69,
        date: DateTime.now(),
        category: Category.food),
  ];

  void saveExpense(Expense expense) {
    setState(() {
      _reqisteredExpenses.add(expense);
    });
  }

  void toggleThemeMode() {
    widget.toggleThemMode();
  }

  void removeExpense(Expense expense) {
    final expenseIndex = _reqisteredExpenses.indexOf(expense);
    setState(() {
      _reqisteredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text('Expense deleted.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          setState(() {
            _reqisteredExpenses.insert(expenseIndex, expense);
          });
        },
      ),
    ));
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(saveExpense: saveExpense),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    if (_reqisteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
          expenses: _reqisteredExpenses, removeExpense: removeExpense);
    }
    return AnimatedTheme(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter ExpenseTracker'),
          actions: [
            IconButton(
                onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
            IconButton(
              onPressed: toggleThemeMode,
              icon: Icon(
                Theme.of(context).brightness == Brightness.light
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Chart(expenses: _reqisteredExpenses),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }
}
