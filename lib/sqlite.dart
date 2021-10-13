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

  // 데이터 생성
  createData(History history) async {
    final db = await database;
    var res = await db.rawInsert(
        'INSERT INTO $tableName(date, activity) VALUES(?, ?)',
        [history.date, history.activity]);
    return res;
  }

  // id로 하나 검색
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

  // 모든 데이터 검색
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

  // 특정 달로 검색
  Future<List<History>> getHistorysByMonth() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $tableName WHERE date');

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

  // id로 데이터 삭제
  deleteHistory(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $tableName WHERE id = ?', [id]);
    return res;
  }

  // 모든 데이터 삭제
  deleteAllHistorys() async {
    final db = await database;
    db.rawDelete('DELETE FROM $tableName');
  }

  String getCurDateTime() {
    return DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().millisecondsSinceEpoch)
        .toString();
  }
}
