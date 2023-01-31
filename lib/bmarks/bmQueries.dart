import 'dart:async';
import 'package:bibliasacra/bmarks/bmModel.dart';
import 'package:bibliasacra/bmarks/bmProvider.dart';
import 'package:sqflite/sqflite.dart';

// Bookmarks database helper

BmProvider _bmProvider;

class BmQueries {
  final String tableName = 'bmks_table';

  BmQueries() {
    _bmProvider = BmProvider();
  }

// returns insert id
  Future<int> saveBookMark(BmModel model) async {
    final db = await _bmProvider.database;

    return await db.insert(
      tableName,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteBookMark(int id) async {
    final db = await _bmProvider.database;
    return await db.rawDelete("DELETE FROM $tableName WHERE id=?", [id]);
  }

  Future<List<BmModel>> getBookMarkList() async {
    final db = await _bmProvider.database;
    var res = await db.rawQuery("SELECT * FROM $tableName ORDER BY id DESC");

    List<BmModel> list = res.isNotEmpty
        ? res.map((tableName) => BmModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List<BmModel>> getBookMarksVersionList(int v) async {
    final db = await _bmProvider.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName WHERE version=?''', [v]);

    List<BmModel> list = res.isNotEmpty
        ? res.map((tableName) => BmModel.fromJson(tableName)).toList()
        : [];

    return list;
  }
}
