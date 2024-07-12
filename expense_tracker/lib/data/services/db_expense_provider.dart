import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/expense.dart';
import '../../domain/models/user.dart';

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

  Future<Users?> getUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return Users.fromMap(maps.first);
    } else {
      return null;
    }
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
