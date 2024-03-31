import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.saveExpense, });

 final void Function(Expense expense)  saveExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveExpense(){
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <=0;

    if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null){
      showDialog(context: context, builder: (ctx) => AlertDialog(
        title: const Text('Invalid Input'),
        content: const Text(
          'Please make sure  a valid title ,amount, date and category was entered'
        ),
        actions: [
          TextButton(onPressed: () {
            Navigator.pop(ctx);
          }, child: const Text('Okay'))
        ],
      ));
      return;
    }

    final submitExpense =  Expense(title: _titleController.text, amount: enteredAmount, date: _selectedDate!, category: _selectedCategory);
    widget.saveExpense(submitExpense);
    Navigator.pop(context);
  }

@override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10,48,10,16),
    child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration:  InputDecoration(
              label: Text('Title' , style: Theme.of(context).textTheme.titleLarge,),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration:  InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount' , style: Theme.of(context).textTheme.titleLarge,),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: Column( // Add this
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(_selectedDate == null
                              ? 'No date selected'
                              : formatter.format(_selectedDate!) , style: Theme.of(context).textTheme.titleLarge,),
                          IconButton(
                            onPressed: _presentDatePicker,
                            icon: const Icon(Icons.calendar_month),
                          ),
                        ],
                      ),
                    ],
                  )),
            ],
          ),
          // ... other code remains the same
          
            const SizedBox(height: 16,),
            Row(
              children: [
                DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase() , style: Theme.of(context).textTheme.titleLarge,),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    }),
                    const Spacer(),
                TextButton(
                  onPressed: () {
                    //Bu class'i ortadan kaldirir
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: _saveExpense,
                    child: const Text('Save Expense'))
              ],
            )
        ],
      ),
  );
}
}
