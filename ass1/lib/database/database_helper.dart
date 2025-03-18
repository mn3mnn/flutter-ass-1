import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/widgets.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

    Future<Database> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is ready

    try {
      String path = join(await getDatabasesPath(), 'users.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            '''CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL, 
              email TEXT UNIQUE NOT NULL, 
              studentId TEXT UNIQUE NOT NULL, 
              password TEXT NOT NULL
            )''',
          );
        },
      );
    } catch (e) {
      debugPrint("Database initialization failed: $e");
      rethrow;
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    int result = await db.insert('users', user);
  
    print("User Inserted: $user"); 

    return result;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }
}
