import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {

  static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDB(); 
      return _db;
    }else{
      return _db;
    }
    
  }
 
  initialDB() async{
    String databasesPath = await getDatabasesPath();
    String Path = join(databasesPath, 'users.db');

    Database mydb = await openDatabase(Path, onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);

    return mydb;

  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("Upgrading the database from $oldVersion to $newVersion");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE "users" 
    ("id" INTEGER PRIMARY KEY,
    "name" TEXT,
    "email" TEXT,
    "studentId" TEXT,
    "password" TEXT)''');

    print("Table is created");

  }


  readData(String sql) async {
    Database? mydb = await db;
    Future<List<Map<String, Object?>>> response = mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    var response = mydb!.rawDelete(sql);
    return response;
  }

}
