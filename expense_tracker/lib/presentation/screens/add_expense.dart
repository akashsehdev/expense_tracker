import 'package:intl/intl.dart';
import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/btn.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/services/db_expense_provider.dart';
import '../../domain/models/expense.dart';

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
  DateTime? _selectedDate; // Use DateTime for storing the selected date
  String _type = 'expense';

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amount = widget.expense!.amount;
      _description = widget.expense!.description;
      _selectedDate = DateTime.parse(
          widget.expense!.date!); // Parse stored date string to DateTime
      _type = widget.expense!.type!;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          title: textWidget(
            title: widget.expense == null ? 'Add Expense' : 'Edit Expense',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //Amount
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: size.width * .9,
                    height: 55,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      initialValue: _amount?.toString(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.currency_rupee_rounded),
                        labelText: 'Amount',
                        labelStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 54, 111, 56)),
                      ),
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
                  ),

                  //Description
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: size.width * .9,
                    height: 115,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextFormField(
                      maxLength: 50,
                      maxLines: 2,
                      initialValue: _description,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(Icons.description),
                          labelText: 'Description',
                          labelStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 54, 111, 56))),
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
                  ),

                  //Date
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: size.width * .9,
                    height: 55,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: _selectedDate == null
                                ? ''
                                : DateFormat('yyyy-MM-dd').format(
                                    _selectedDate!), // Format selected date if not null
                          ),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.date_range),
                              labelText: 'Date',
                              labelStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Color.fromARGB(255, 54, 111, 56))),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  //Income or Expense
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    width: size.width * .9,
                    height: 55,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _type,
                      items: [
                        DropdownMenuItem(
                          child: textWidget(title: 'Expense'),
                          value: 'expense',
                        ),
                        DropdownMenuItem(
                            child: textWidget(title: 'Income'),
                            value: 'income'),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _type = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Type',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Btn(
                      label: widget.expense == null ? 'Submit' : 'Update',
                      press: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final expense = Expense(
                            id: widget.expense?.id,
                            amount: _amount!,
                            description: _description!,
                            date: _selectedDate != null
                                ? DateFormat('yyyy-MM-dd').format(
                                    _selectedDate!) // Format selected date if not null
                                : '',
                            type: _type,
                          );
                          final dbProvider = Provider.of<DatabaseProvider>(
                              context,
                              listen: false);
                          if (widget.expense == null) {
                            await dbProvider.insertExpense(
                                expense, widget.userId);
                          } else {
                            await dbProvider.updateExpense(expense);
                          }
                          Navigator.of(context).pop(
                              true); // Return true to indicate the list should be refreshed
                        }
                      },
                      txtColor: backgroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      backgroundColor: bgColor)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show date picker and update selectedDate
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
