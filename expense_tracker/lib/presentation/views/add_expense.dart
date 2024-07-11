// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../data/models/expense.dart';
// import '../../data/services/db_expense_provider.dart';

// class AddExpenseScreen extends StatefulWidget {
//   final Expense? expense;

//   AddExpenseScreen({this.expense});

//   @override
//   _AddExpenseScreenState createState() => _AddExpenseScreenState();
// }

// class _AddExpenseScreenState extends State<AddExpenseScreen> {
//   final _formKey = GlobalKey<FormState>();
//   double? _amount;
//   String? _description;
//   String? _date;
//   String _type = 'expense';

//   @override
//   void initState() {
//     super.initState();
//     if (widget.expense != null) {
//       _amount = widget.expense!.amount;
//       _description = widget.expense!.description;
//       _date = widget.expense!.date;
//       _type = widget.expense!.type!;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: <Widget>[
//               TextFormField(
//                 initialValue: _amount?.toString(),
//                 decoration: InputDecoration(labelText: 'Amount'),
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter an amount';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _amount = double.parse(value!);
//                 },
//               ),
//               TextFormField(
//                 initialValue: _description,
//                 decoration: InputDecoration(labelText: 'Description'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a description';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _description = value!;
//                 },
//               ),
//               TextFormField(
//                 initialValue: _date,
//                 decoration: InputDecoration(labelText: 'Date'),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a date';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   _date = value!;
//                 },
//               ),
//               DropdownButtonFormField<String>(
//                 value: _type,
//                 items: [
//                   DropdownMenuItem(child: Text('Expense'), value: 'expense'),
//                   DropdownMenuItem(child: Text('Income'), value: 'income'),
//                 ],
//                 onChanged: (value) {
//                   setState(() {
//                     _type = value!;
//                   });
//                 },
//                 decoration: InputDecoration(labelText: 'Type'),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 child: Text(widget.expense == null ? 'Add' : 'Update'),
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     final expense = Expense(
//                       id: widget.expense?.id,
//                       amount: _amount!,
//                       description: _description!,
//                       date: _date!,
//                       type: _type,
//                     );
//                     final dbProvider =
//                         Provider.of<DatabaseProvider>(context, listen: false);
//                     if (widget.expense == null) {
//                       await dbProvider.insertExpense(expense, );
//                     } else {
//                       await dbProvider.updateExpense(expense);
//                     }
//                     Navigator.of(context).pop(
//                         true); // Return true to indicate the list should be refreshed
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense.dart';
import '../../data/services/db_expense_provider.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expense;
  final int userId; // Add userId property

  AddExpenseScreen({required this.userId, this.expense});

  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  double? _amount;
  String? _description;
  String? _date;
  String _type = 'expense';

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amount = widget.expense!.amount;
      _description = widget.expense!.description;
      _date = widget.expense!.date;
      _type = widget.expense!.type!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _amount?.toString(),
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
                onSaved: (value) {
                  _amount = double.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                initialValue: _date,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
                onSaved: (value) {
                  _date = value!;
                },
              ),
              DropdownButtonFormField<String>(
                value: _type,
                items: [
                  DropdownMenuItem(child: Text('Expense'), value: 'expense'),
                  DropdownMenuItem(child: Text('Income'), value: 'income'),
                ],
                onChanged: (value) {
                  setState(() {
                    _type = value!;
                  });
                },
                decoration: InputDecoration(labelText: 'Type'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.expense == null ? 'Add' : 'Update'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final expense = Expense(
                      id: widget.expense?.id,
                      amount: _amount!,
                      description: _description!,
                      date: _date!,
                      type: _type,
                    );
                    final dbProvider =
                        Provider.of<DatabaseProvider>(context, listen: false);
                    if (widget.expense == null) {
                      await dbProvider.insertExpense(expense, widget.userId);
                    } else {
                      await dbProvider.updateExpense(expense);
                    }
                    Navigator.of(context).pop(
                        true); // Return true to indicate the list should be refreshed
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
