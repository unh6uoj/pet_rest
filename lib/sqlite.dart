import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class History {
  int? id = 0;
  String? date = "";
  String? activity = "";

  History({this.id, this.date, this.activity});

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'activity': activity};
  }
}

class HistoryDBHelper {
  HistoryDBHelper._();
  static final HistoryDBHelper _db = HistoryDBHelper._();
  factory HistoryDBHelper() => _db;

  // 작업중

  final Future<Database> database = getDatabasesPath().then((String path) {
    return openDatabase(
      join(path, 'database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE user_history(id INTEGER PRIMARY KEY, date TEXT, activity TEXT)",
        );
      },
      version: 1,
    );
  });
}
