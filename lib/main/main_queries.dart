import 'dart:async';
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bibliasacra/main/main_model.dart';
import 'package:bibliasacra/main/main_provider.dart';

// imain_queries.dart

DbProvider? _dbProvider;

String getBVFileName(int bibleVersion) {
  String dbName = '';

  switch (bibleVersion) {
    case 1:
      dbName = Constants.kjvbDbname;
      break;
    case 2:
      dbName = Constants.clemDbname;
      break;
    case 3:
      dbName = Constants.cpdvDbname;
      break;
    case 4:
      dbName = Constants.nvulDbname;
      break;
    case 5:
    // _dbName = Constants.af53Dbname;
    // break;
    case 6:
    // _dbName = Constants.dn33Dbname;
    // break;
    case 7:
      dbName = Constants.ukjvDbname;
      break;
    case 8:
      dbName = Constants.webbDbname;
      break;
    // case 9:
    //   dbName = Constants.af83Dbname;
    //   break;
    case 10:
      dbName = Constants.asvbDbname;
      break;
    default:
      dbName = Constants.kjvbDbname;
  }

  return dbName;
}

class DbQueries {
  final String tableName = 'bible';
  int bibleVersion;

  DbQueries(this.bibleVersion) {
    String dbName = getBVFileName(bibleVersion);
    _dbProvider = DbProvider(dbName);
  }

  Future<List<Bible>> getBookChapter(int b, int c) async {
    final db = await _dbProvider!.database;

    List<Bible> list = [];
    List<Bible> emptyList = [];

    final mod = Bible(id: 0, b: 0, c: 0, v: 0, t: ' ');
    for (int l = 1; l <= 35; l++) {
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

  Future<List<Bible>> getSampleChapter(int b, int c) async {
    final db = await _dbProvider!.database;

    List<Bible> list = [];

    var res = await db
        .rawQuery('''SELECT * FROM $tableName WHERE b=? AND c=?''', [b, c]);

    if (res.isNotEmpty) {
      list = res.map((tableName) => Bible.fromJson(tableName)).toList();
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

    List<Bible> returnList = [];
    final defList = Bible(id: 0, b: 0, c: 0, v: 0, t: 'No search results.');
    returnList.add(defList);

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE t LIKE '%$search%' AND b BETWEEN ? AND ? ORDER BY id ASC''',
        [low, high]);

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
}
