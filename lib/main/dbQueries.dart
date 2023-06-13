import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:bibliasacra/main/dbModel.dart';
import 'package:bibliasacra/main/dbProvider.dart';

// Bible database queries

DbProvider? _dbProvider;

class DbQueries {
  final String tableName = 'bible';

  DbQueries() {
    _dbProvider = DbProvider();
  }

  Future<List<Bible>> getBookChapter(int b, int c) async {
    final db = await _dbProvider!.database;

    List<Bible> list = [];
    List<Bible> emptyList = [];

    final mod = Bible(id: 0, b: 0, c: 0, v: 0, t: ' ');
    for (int l = 1; l <= 30; l++) {
      emptyList.add(mod);
    }

    var res = await db
        .rawQuery('''SELECT * FROM $tableName WHERE b=? AND c=?''', [b, c]);

    if (res.isNotEmpty) {
      list = res.map((tableName) => Bible.fromJson(tableName)).toList();
      list.insertAll(list.length, emptyList);
    }

    return list;
  }

  Future<List<Bible>> getVerse(int book, int chap, int verse) async {
    final db = await _dbProvider!.database;

    List<Bible> returnList = [];
    final defList = Bible(id: 0, b: 0, c: chap, v: verse, t: 'Verse not found');
    returnList.add(defList);

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE b=? AND c=? AND v=?''',
        [book, chap, verse]);

    List<Bible> list = res.isNotEmpty
        ? res.map((tableName) => Bible.fromJson(tableName)).toList()
        : returnList;

    return list;
  }

  Future<List<Bible>> getSearchedValues(
      String search, String low, String high) async {
    final db = await _dbProvider!.database;

    //debugPrint("TEXT $search LOW $low HIGH $high");

    List<Bible> returnList = [];
    final defList = Bible(id: 0, b: 0, c: 0, v: 0, t: 'No search results.');
    returnList.add(defList);

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE t LIKE ? AND b BETWEEN ? AND ? ORDER BY id ASC''',
        ['%$search%', low, high]);

    List<Bible> list = res.isNotEmpty
        ? res.map((tableName) => Bible.fromJson(tableName)).toList()
        : returnList;

    return list;
  }

  Future<int> getChapterCount(int b) async {
    final db = await _dbProvider!.database;

    var cnt = Sqflite.firstIntValue(
      await db.rawQuery('''SELECT MAX(c) FROM $tableName WHERE b=?''', [b]),
    );
    return cnt ?? 0;
  }

  Future<int> getVerseCount(int b, int c) async {
    final db = await _dbProvider!.database;

    var cnt = Sqflite.firstIntValue(
      await db.rawQuery(
          '''SELECT MAX(v) FROM $tableName WHERE b=? AND c=?''', [b, c]),
    );
    return cnt ?? 0;
  }

// returns number of affected rows
  // Future<int> updateHighlightId(int h, int id) async {
  //   final db = await _dbProvider.database;

  //   return await db.rawUpdate('''UPDATE $tableName SET h=? WHERE id=?''',
  //       [h, id]); // highlight id and bible verse id
  // }

  // returns number of affected rows
  // Future<int> updateNoteId(int n, int id) async {
  //   final db = await _dbProvider.database;

  //   return await db.rawUpdate('''UPDATE $tableName SET n=? WHERE id=?''',
  //       [n, id]); // note id and bible verse id
  // }
}
