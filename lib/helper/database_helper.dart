import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    final String databasesPath = await getDatabasesPath();
    final String path = join(databasesPath, 'logindb.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY,
        usermail TEXT,
        password TEXT
      )
      ''');
  }

  Future<int> saveUser(Map<String, dynamic> user) async {
    final Database dbClient = await db;
    return await dbClient.insert('User', user);
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final Database dbClient = await db;
    return await dbClient.query('User');
  }

  Future<Map<String, dynamic>?> getUser(String usermail) async {
    final Database dbClient = await db;
    List<Map<String, dynamic>> users = await dbClient.query('User',
        where: 'usermail = ?', whereArgs: [usermail], limit: 1);
    return users.isNotEmpty ? users.first : null;
  }
}