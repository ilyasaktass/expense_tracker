import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses.dart';

void main() {
  runApp( MaterialApp(
    theme: ThemeData().copyWith(
      scaffoldBackgroundColor: Color.fromARGB(255, 191, 115, 254),
      
    ),
    home: Expenses(),
  ));
}