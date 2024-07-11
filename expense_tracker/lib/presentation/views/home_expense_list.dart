import 'package:expense_tracker/presentation/components/TextWidget.dart';
import 'package:expense_tracker/presentation/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/expense.dart';
import '../../data/models/user.dart';
import '../../data/provider/provider_.dart';
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
      body: FutureBuilder<List<Expense>>(
        future: dbProvider.getSQLiteExpenses(widget.userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final expenses = snapshot.data!;
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

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                // color: Colors.grey.shade200,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                builder: (context) => AddExpenseScreen(
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
                                          title: expense.description!,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
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
                                        color: expense.type! == 'income'
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
                                          _showDeleteDialog(context, expense);
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
              ),
            ],
          );
        },
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
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Delete'),
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
