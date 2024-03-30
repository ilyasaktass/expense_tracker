import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.removeExpense});
  final void Function(Expense expense) removeExpense;

  final List<Expense> expenses;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        onDismissed: (direction) => removeExpense(expenses[index]),
        key: ValueKey(expenses[index]),
        background: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(
              horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Add border radius here
            color: Theme.of(context).colorScheme.error.withOpacity(0.75 - 0.25 * (index % 3)),
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        child: ExpenseItem(expenses[index]),
      ),
    );
  }
}
