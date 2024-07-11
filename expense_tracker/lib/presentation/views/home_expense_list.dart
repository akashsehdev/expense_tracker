import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/expense.dart';
import '../../data/models/user.dart';
import '../../data/provider/provider_.dart';
import '../../data/services/db_expense_provider.dart';
import '../../data/services/db_helper.dart';
import '../components/controllers_.dart';
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
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          Consumer<UiProvider>(
            builder: (context, UiProvider notifier, child) {
              return IconButton(
                icon: Icon(Icons.logout),
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

          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];

              return ListTile(
                title: Text(expense.description!),
                subtitle: Text('${expense.amount!} - ${expense.date}'),
                trailing: Text(expense.type!),
                onLongPress: () {
                  _showDeleteDialog(context, expense);
                },
                onTap: () async {
                  bool? shouldRefresh = await Navigator.of(context).push(
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
              );
            },
          );
        },
      ),

      // FutureBuilder<List<Expense>>(
      //   future: dbProvider
      //       .getExpenses(widget.userId), // Pass userId to getExpenses()
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return Center(child: CircularProgressIndicator());
      //     }

      //     final expenses = snapshot.data!;

      //     return ListView.builder(
      //       itemCount: expenses.length,
      //       itemBuilder: (context, index) {
      //         final expense = expenses[index];

      //         return ListTile(
      //           title: Text(expense.description!),
      //           subtitle: Text('${expense.amount!} - ${expense.date}'),
      //           trailing: Text(expense.type!),
      //           onLongPress: () {
      //             _showDeleteDialog(context, expense);
      //           },
      //           onTap: () async {
      //             bool? shouldRefresh = await Navigator.of(context).push(
      //               MaterialPageRoute(
      //                 builder: (context) => AddExpenseScreen(
      //                   expense: expense,
      //                   userId:
      //                       widget.userId, // Pass userId to AddExpenseScreen
      //                 ),
      //               ),
      //             );
      //             if (shouldRefresh == true) {
      //               setState(() {});
      //             }
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(
                  userId: widget.userId), // Pass userId to AddExpenseScreen
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExpenseList(userId: widget.userId)),
                );
              },
              icon: Icon(
                Icons.home,
                size: 30,
              ),
            ),
            Builder(builder: (context) {
              return IconButton(
                onPressed: () async {
                  Users? userDetails = await db.getUser(widget.userId
                      .toString()); // Fetch user details using userId
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
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () async {
              await Provider.of<DatabaseProvider>(context, listen: false)
                  .deleteExpense(expense.id!);
              Navigator.of(ctx).pop();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
