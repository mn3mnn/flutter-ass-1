import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
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
    try {
      String path = join(await getDatabasesPath(), 'users.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT NOT NULL, 
              email TEXT UNIQUE NOT NULL, 
              studentId TEXT UNIQUE NOT NULL, 
              password TEXT NOT NULL,
              gender TEXT, 
              level INT,
              image TEXT
            )''');
        },
      );
    } catch (e) {
      debugPrint("Database initialization failed: $e");
      rethrow;
    }
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    try {
      int result = await db.insert(
        'users',
        user,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint("User Inserted: $user");
      return result;
    } catch (e) {
      debugPrint("Insert failed: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    try {
      return await db.query('users');
    } catch (e) {
      debugPrint("Get all users failed: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    try {
      List<Map<String, dynamic>> result = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );
      debugPrint("Get user by email returned: $result");
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      debugPrint("Get user by email failed: $e");
      return null;
    }
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    try {
      return await db.delete('users', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint("Delete user failed: $e");
      return -1;
    }
  }

  Future<int> updateUser(int id, Map<String, dynamic> updatedData) async {
    final db = await database;
    try {
      return await db.update(
        'users',
        updatedData,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint("Update user failed: $e");
      return -1;
    }
  }
}
