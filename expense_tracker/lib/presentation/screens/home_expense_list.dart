import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/btn.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/expense.dart';
import '../../domain/models/user.dart';
import '../../domain/provider/provider_.dart';
import '../../data/services/db_expense_provider.dart';
import '../../data/services/db_helper.dart';
import 'profile.dart';
import 'add_expense.dart'; // Ensure to import AddExpenseScreen

class ExpenseList extends StatefulWidget {
  final int userId; // Add userId property

  ExpenseList({required this.userId});

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  final db = DatabaseHelper();
  String selectedSortOption = 'Date';
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    final dbProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        title: textWidget(
          title: 'Expense Tracker',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Consumer<UiProvider>(
            builder: (context, UiProvider notifier, child) {
              return IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  notifier.logout(context);
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<List<Expense>>(
            future: dbProvider.getSQLiteExpenses(widget.userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              List<Expense> expenses = snapshot.data!;

              // Apply sorting
              if (selectedSortOption == 'Date') {
                expenses.sort((a, b) => a.date!.compareTo(b.date!));
              } else if (selectedSortOption == 'Amount') {
                expenses.sort((a, b) => a.amount!.compareTo(b.amount!));
              }

              // Apply filtering
              if (startDate != null && endDate != null) {
                expenses = expenses.where((expense) {
                  final expenseDate = DateTime.parse(expense.date!);
                  return expenseDate
                          .isAfter(startDate!.subtract(Duration(days: 1))) &&
                      expenseDate.isBefore(endDate!.add(Duration(days: 1)));
                }).toList();
              }

              double totalIncome = 0;
              double totalExpenses = 0;

              // Calculate total income and expenses
              expenses.forEach((expense) {
                if (expense.type! == 'income') {
                  totalIncome += expense.amount!;
                } else if (expense.type! == 'expense') {
                  totalExpenses += expense.amount!;
                }
              });

              // Calculate total balance
              double totalBalance = totalIncome - totalExpenses;

              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                title: 'Balance',
                                color: const Color.fromARGB(255, 138, 138, 138),
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              textWidget(
                                title: '\₹$totalBalance',
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textWidget(
                                title: 'Replenish',
                                color: const Color.fromARGB(255, 138, 138, 138),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  textWidget(
                                    title: '\₹ $totalIncome',
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_up_rounded,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  textWidget(
                                    title: '\₹ $totalExpenses',
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top: 15),
                        decoration: const BoxDecoration(
                            color: listBgColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            )),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DropdownButton<String>(
                                    dropdownColor:
                                        secondaryColor, // Sets the background color of the dropdown menu
                                    value: selectedSortOption,
                                    style: TextStyle(
                                        color: Colors
                                            .white), // Sets the color of the selected item text
                                    icon: Icon(Icons.arrow_drop_down,
                                        color: Colors
                                            .white), // Sets the color of the dropdown icon
                                    items: <String>[
                                      'Date',
                                      'Amount',
                                      'None'
                                    ] // Add 'None' option for clearing sort
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: textWidget(
                                          title: value,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        if (newValue == 'None') {
                                          selectedSortOption =
                                              'Date'; // Default to 'Date' when clearing sort
                                        } else {
                                          selectedSortOption = newValue!;
                                        }
                                      });
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Btn(
                                          label: 'Filter by Date',
                                          width: 120,
                                          press: () async {
                                            final picked =
                                                await showDateRangePicker(
                                              context: context,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                startDate = picked.start;
                                                endDate = picked.end;
                                              });
                                            }
                                          },
                                          txtColor: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          backgroundColor: backgroundColor),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              startDate = null;
                                              endDate = null;
                                            });
                                          },
                                          icon: Icon(Icons.clear_rounded)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: expenses.length,
                                itemBuilder: (context, index) {
                                  final expense = expenses[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        bool? shouldRefresh =
                                            await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddExpenseScreen(
                                              expense: expense,
                                              userId: widget.userId,
                                            ),
                                          ),
                                        );
                                        if (shouldRefresh == true) {
                                          setState(() {});
                                        }
                                      },
                                      child: Material(
                                        elevation: 2,
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  textWidget(
                                                    title: '${expense.amount!}',
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                  Container(
                                                    width: 170,
                                                    child: textWidget(
                                                      title:
                                                          expense.description!,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: bgColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  textWidget(
                                                    title: expense.type!,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: expense.type! ==
                                                            'income'
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  textWidget(
                                                    title: '${expense.date}',
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showDeleteDialog(
                                                          context, expense);
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      size: 24,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddExpenseScreen(
                  userId: widget.userId,
                ),
              ),
            );
          },
          elevation: 50,
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 20,
        color: backgroundColor,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpenseList(userId: widget.userId),
                  ),
                );
              },
              icon: Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(),
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () async {
                    Users? userDetails = await db.getUserById(widget.userId);
                    if (userDetails != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(profile: userDetails),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("User not found."),
                      ));
                    }
                  },
                  icon: Icon(
                    Icons.person_rounded,
                    size: 30,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: backgroundColor,
        title: textWidget(
          title: 'Delete Expense',
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        content: textWidget(
          title: 'Are you sure you want to delete this expense?',
          color: Colors.white,
        ),
        actions: [
          TextButton(
            child: textWidget(title: 'Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: textWidget(title: 'Delete'),
            onPressed: () async {
              await Provider.of<DatabaseProvider>(context, listen: false)
                  .deleteExpense(expense.id!);
              Navigator.of(context).pop();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
