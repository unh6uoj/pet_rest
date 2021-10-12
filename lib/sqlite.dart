import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class History {
  late int id;
  late String date;
  late String activity;

  History({required this.id, required this.date, required this.activity});
}

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database? _database;
  Future<Database> get database async => _database ??= await initDB();

  String tableName = 'user_history';

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'PetStation.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE $tableName (
            id INTEGER PRIMARY KEY,
            date TEXT,
            activity TEXT
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  //Create
  createData(History history) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $tableName(date, activity) VALUES(?, ?)',
        [history.date, history.activity]);
    return res;
  }

  //Read
  get(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName WHERE id = ?', [id]);
    return res.isNotEmpty
        ? History(
            id: res.first['id'] as int,
            date: res.first['date'] as String,
            activity: res.first['activity'] as String)
        : Null;
  }

  //Read All
  Future<List<History>> getAllHistorys() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName');
    List<History> list = res.isNotEmpty
        ? res
            .map((c) => History(
                id: c['id'] as int,
                date: c['date'] as String,
                activity: c['activity'] as String))
            .toList()
        : [];

    return list;
  }

  //Delete
  deleteHistory(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllHistorys() async {
    final db = await database;
    db.rawDelete('DELETE FROM $tableName');
  }
}
