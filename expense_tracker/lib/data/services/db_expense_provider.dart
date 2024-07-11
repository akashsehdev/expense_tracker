// import 'package:flutter/foundation.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/expense.dart';

// class DatabaseProvider with ChangeNotifier {
//   static final DatabaseProvider _instance = DatabaseProvider._();
//   static Database? _database;

//   DatabaseProvider._();

//   factory DatabaseProvider() {
//     return _instance;
//   }

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     return openDatabase(
//       join(await getDatabasesPath(), 'expenses_database.db'),
//       onCreate: (db, version) async {
//         await db.execute(
//           'CREATE TABLE expenses(id INTEGER PRIMARY KEY, amount REAL, description TEXT, date TEXT, type TEXT)',
//         );
//       },
//       version: 1,
//     );
//   }

//   Future<void> insertExpense(Expense expense) async {
//     final db = await database;
//     await db.insert(
//       'expenses',
//       expense.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     notifyListeners();
//   }

//   Future<List<Expense>> getExpenses() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query('expenses');

//     return List.generate(maps.length, (i) {
//       return Expense.fromMap(maps[i]);
//     });
//   }

//   Future<void> updateExpense(Expense expense) async {
//     final db = await database;
//     await db.update(
//       'expenses',
//       expense.toMap(),
//       where: 'id = ?',
//       whereArgs: [expense.id],
//     );
//     notifyListeners();
//   }

//   Future<void> deleteExpense(int id) async {
//     final db = await database;
//     await db.delete(
//       'expenses',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//     notifyListeners();
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/user.dart';
// import '../models/expense.dart';

// class DatabaseProvider with ChangeNotifier{
//   static final DatabaseProvider _instance = DatabaseProvider._internal();
//   factory DatabaseProvider() => _instance;

//   DatabaseProvider._internal();

//   Future<void> saveUser(Users user) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('user', usersToMap(user));
//     notifyListeners();
//   }

//   Future<Users?> getUser() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String? userJson = prefs.getString('user');
//     if (userJson != null) {
//       return usersFromMap(userJson);
//     }
//     return null;

//   }

//   Future<void> saveExpenses(List<Expense> expenses, int userId) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String key = 'expenses_$userId';
//     prefs.setStringList(
//       key,
//       expenses.map((e) => jsonEncode(e.toMap())).toList(),
//     );
//     notifyListeners();
//   }

//   Future<List<Expense>> getExpenses(int userId) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String key = 'expenses_$userId';
//     final List<String>? expensesJson = prefs.getStringList(key);
//     if (expensesJson != null) {
//       return expensesJson.map((e) => Expense.fromMap(jsonDecode(e))).toList();
//     }
//     return [];
//   }

//   // Example authenticate method, adjust as needed
//   Future<bool> authenticate(Users user) async {
//     // Logic to authenticate user, return true or false based on authentication result
//     // For example:
//     // return user.userName == 'test' && user.userPassword == 'password';
//     return true; // Replace with actual logic
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class DatabaseProvider with ChangeNotifier {
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  // SQLite database instance
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            userId INTEGER,
            amount REAL,
            date TEXT,
            description TEXT,
            type TEXT
          )
        ''');
      },
    );
  }

  // SQLite CRUD operations for Expense

  Future<void> insertExpense(Expense expense, int userId) async {
    final db = await database;
    await db.insert(
      'expenses',
      {
        'userId': userId,
        'amount': expense.amount,
        'date': expense.date,
        'description': expense.description,
        'type': expense.type,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    notifyListeners();
  }

  Future<void> deleteExpense(int id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

  // SharedPreferences for saving and retrieving expenses

  Future<void> saveExpenses(List<Expense> expenses, int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = 'expenses_$userId';
    prefs.setStringList(
      key,
      expenses.map((e) => jsonEncode(e.toMap())).toList(),
    );
  }

  Future<List<Expense>> getExpenses(int userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String key = 'expenses_$userId';
    final List<String>? expensesJson = prefs.getStringList(key);
    if (expensesJson != null) {
      return expensesJson.map((e) => Expense.fromMap(jsonDecode(e))).toList();
    }
    return [];
  }

  // Get expenses from SQLite for a specific user
  Future<List<Expense>> getSQLiteExpenses(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('expenses', where: 'userId = ?', whereArgs: [userId]);
    return List.generate(maps.length, (i) {
      return Expense(
        id: maps[i]['id'],
        amount: maps[i]['amount'],
        date: maps[i]['date'],
        description: maps[i]['description'],
        type: maps[i]['type'],
      );
    });
  }

  // Update expense in SQLite
  Future<void> updateSQLiteExpense(Expense expense) async {
    final db = await database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    notifyListeners();
  }

  // Delete expense from SQLite
  Future<void> deleteSQLiteExpense(int id) async {
    final db = await database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }
}
