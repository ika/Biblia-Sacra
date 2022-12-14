import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bibliasacra/main/dbModel.dart';
import 'package:bibliasacra/main/dbProvider.dart';

// Bible database queries

DbProvider _dbProvider;

class DbQueries {
  final String tableName = 'bible';

  DbQueries() {
    _dbProvider = DbProvider();
  }

  Future<List<Bible>> getBookChapter(int b, int c) async {
    final db = await _dbProvider.database;

    var res = await db
        .rawQuery('''SELECT * FROM $tableName WHERE b=? AND c=?''', [b, c]);

    List<Bible> list = res.isNotEmpty
        ? res.map((tableName) => Bible.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List<Bible>> getVerse(int book, int chap, int verse) async {
    final db = await _dbProvider.database;

    List<Bible> returnList = [];
    final defList =
        Bible(id: 0, b: 0, c: chap, v: verse, t: 'Verse not found', h: 0, n: 0, m: 0);
    returnList.add(defList);

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE b=? AND c=? AND v=?''',
        [book, chap, verse]);

    List<Bible> list = res.isNotEmpty
        ? res.map((tableName) => Bible.fromJson(tableName)).toList()
        : returnList;

    return list;
  }

  Future<List<Bible>> getSearchedValues(String s, String l, String h) async {
    // text, low, high
    final db = await _dbProvider.database;

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE t LIKE ? AND b BETWEEN ? AND ?''',
        ['%$s%', l, h]);

    List<Bible> list = res.isNotEmpty
        ? res.map((tableName) => Bible.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<int> getChapterCount(int b) async {
    final db = await _dbProvider.database;

    return Sqflite.firstIntValue(
      await db.rawQuery('''SELECT MAX(c) FROM $tableName WHERE b=?''', [b]),
    );
  }

  Future<int> getVerseCount(int b, int c) async {
    final db = await _dbProvider.database;

    int cnt = Sqflite.firstIntValue(
      await db.rawQuery(
          '''SELECT MAX(v) FROM $tableName WHERE b=? AND c=?''', [b, c]),
    );
    return cnt;
  }

// returns number of affected rows
  Future<int> updateHighlightId(int h, int id) async {
    final db = await _dbProvider.database;

    return await db.rawUpdate('''UPDATE $tableName SET h=? WHERE id=?''',
        [h, id]); // highlight id and bible verse id
  }

  // returns number of affected rows
  Future<int> updateNoteId(int n, int id) async {
    final db = await _dbProvider.database;

    return await db.rawUpdate('''UPDATE $tableName SET n=? WHERE id=?''',
        [n, id]); // note id and bible verse id
  }
}
