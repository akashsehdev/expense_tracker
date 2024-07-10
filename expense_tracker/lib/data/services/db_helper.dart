import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class DatabaseHelper {
  final databaseName = "auth.db";

  //tables

  //Don't put comma at the end of a column in sqlite
  String user = '''
  CREATE TABLE users(
    userId INTEGER PRIMARY KEY AUTOINCREMENT,
    fullName TEXT,
    email TEXT,
    userName TEXT UNIQUE,
    userPassword TEXT
  )
''';

  //Our connection is ready
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(user);
    });
  }

  //Function Methods

  //Authentication
  Future<bool> authenticate(Users usr) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
      "SELECT * FROM users WHERE userName = '${usr.userName}' AND userPassword = '${usr.userPassword}'",
    );
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> createUser(Users usr) async {
    final Database db = await initDB();
    return db.insert("users", usr.toMap());
  }

  //Get current user details
  Future<Users?> getUser(String userName) async {
    final Database db = await initDB();
    var res =
        await db.query("users", where: "userName = ?", whereArgs: [userName]);
    return res.isNotEmpty ? Users.fromMap(res.first) : null;
  }
}








// // services/database_service.dart
// import 'package:expense_tracker/data/models/expenses_val.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/user.dart';

// class DatabaseService {
//   static final DatabaseService _instance = DatabaseService._internal();
//   factory DatabaseService() => _instance;
//   static Database? _database;

//   DatabaseService._internal();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }

//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'app_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE users(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         username TEXT,
//         password TEXT
//       )
//     ''');
//     await db.execute('''
//       CREATE TABLE key_points(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         userId INTEGER,
//         amount REAL,
//         description TEXT,
//         date TEXT,
//         tag TEXT,
//         FOREIGN KEY (userId) REFERENCES users(id)
//       )
//     ''');
//   }

//   Future<int> insertUser(User user) async {
//     Database db = await database;
//     return await db.insert('users', user.toMap());
//   }

//   Future<User?> getUser(String username, String password) async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query(
//       'users',
//       where: 'username = ? AND password = ?',
//       whereArgs: [username, password],
//     );
//     if (maps.isNotEmpty) {
//       return User(
//         id: maps.first['id'],
//         username: maps.first['username'],
//         password: maps.first['password'],
//       );
//     }
//     return null;
//   }

//   Future<int> insertKeyPoint(ExpensesVal keyPoint) async {
//     Database db = await database;
//     return await db.insert('key_points', keyPoint.toMap());
//   }

//   Future<List<ExpensesVal>> getKeyPoints(int userId) async {
//     Database db = await database;
//     List<Map<String, dynamic>> maps = await db.query(
//       'key_points',
//       where: 'userId = ?',
//       whereArgs: [userId],
//     );
//     return List.generate(maps.length, (i) {
//       return ExpensesVal(
//         id: maps[i]['id'],
//         userId: maps[i]['userId'],
//         amount: maps[i]['amount'],
//         description: maps[i]['description'],
//         date: DateTime.parse(maps[i]['date']),
//         tag: maps[i]['tag'],
//       );
//     });
//   }

//   Future<int> updateKeyPoint(ExpensesVal keyPoint) async {
//     Database db = await database;
//     return await db.update(
//       'key_points',
//       keyPoint.toMap(),
//       where: 'id = ?',
//       whereArgs: [keyPoint.id],
//     );
//   }

//   Future<int> deleteKeyPoint(int id) async {
//     Database db = await database;
//     return await db.delete(
//       'key_points',
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
// }
