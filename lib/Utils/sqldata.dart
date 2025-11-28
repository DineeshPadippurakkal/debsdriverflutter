  import 'dart:developer';

  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';

  class DBHelper {
    static final DBHelper instance = DBHelper._init();
    static Database? _database;

    DBHelper._init();

    Future<Database> get database async {
      if (_database != null) return _database!;
      _database = await _initDB('user.db');
      return _database!;
    }

    Future<Database> _initDB(String filePath) async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    }

    Future _createDB(Database db, int version) async {
      await db.execute('''
        CREATE TABLE user(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          token TEXT
        )
      ''');
    }

    Future<int> saveUser(String username, String token) async {
      final db = await instance.database;

      await db.delete('user'); // keep only one user

      return await db.insert('user', {
        "username": username,
        "token": token,
      });
    }

    Future showuser() async {
      final db = await instance.database;
      final result = await db.query('user');
      log(result.toString());
    }


    Future<Map<String, dynamic>?> getUser() async {
      final db = await instance.database;

      final result = await db.query('user');

      if (result.isNotEmpty) {
        return result.first;
      }
      return null;
    }
  }
