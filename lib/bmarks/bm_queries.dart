import 'dart:async';
import 'package:bibliasacra/bmarks/bm_model.dart';
import 'package:bibliasacra/bmarks/bm_provider.dart';
import 'package:sqflite/sqflite.dart';

// bm_queries.dart

BmProvider? _bmProvider;

List<BmModel> noneFound() {
  List<BmModel> returnList = [];
  final defList = BmModel(
      id: 0,
      title: 'No Bookmarks found!',
      subtitle: '',
      lang: '',
      version: 0,
      abbr: '',
      book: 0,
      chapter: 0,
      verse: 0,
      name: '',
      bid: 0);
  returnList.add(defList);
  return returnList;
}

class BmQueries {
  final String tableName = 'bmks_table';

  BmQueries() {
    _bmProvider = BmProvider();
  }

// returns insert id
  Future<int> saveBookMark(BmModel model) async {
    final db = await _bmProvider!.database;

    return await db.insert(
      tableName,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  Future<int> deleteBookMark(int id) async {
    final db = await _bmProvider!.database;
    return await db.rawDelete("DELETE FROM $tableName WHERE id=?", [id]);
  }

  Future<int> deleteBookMarkbyBid(int bid) async {
    final db = await _bmProvider!.database;
    return await db.rawDelete("DELETE FROM $tableName WHERE bid=?", [bid]);
  }

  Future<List<BmModel>> getBookMarkList() async {
    final db = await _bmProvider!.database;

    var res = await db.rawQuery("SELECT * FROM $tableName ORDER BY id DESC");

    List<BmModel> list = res.isNotEmpty
        ? res.map((tableName) => BmModel.fromJson(tableName)).toList()
        : noneFound();

    return list;
  }

  Future<List<BmModel>> getBookMarksVersionList(int v) async {
    final db = await _bmProvider!.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName WHERE version=?''', [v]);

    List<BmModel> list = res.isNotEmpty
        ? res.map((tableName) => BmModel.fromJson(tableName)).toList()
        : [];

    return list;
  }
}
