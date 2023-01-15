import 'dart:async';
import 'package:bibliasacra/high/hlModel.dart';
import 'package:bibliasacra/high/hlProvider.dart';
import 'package:sqflite/sqflite.dart';

// Highlights database queries

HlProvider _hlProvider;

class HlQueries {
  final String tableName = 'hlts_table';

  HlQueries() {
    _hlProvider = HlProvider();
  }

  // Future<void> saveDatabaseId(int i, int b) async {
  //   final db = await _hlProvider.database;
  //   await db.rawUpdate('''UPDATE $tableName SET bid=? WHERE id=?''', [b, i]);
  // }

  Future<int> saveHighLight(HlModel model) async {
    final db = await _hlProvider.database;
    return await db.insert(
      tableName,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteHighLight(int bid) async {
    final db = await _hlProvider.database;
    return await db.rawDelete('''DELETE FROM $tableName WHERE bid=?''', [bid]);
  }

  Future<List<HlModel>> getHighLightList() async {
    final db = await _hlProvider.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName ORDER BY id DESC''');

    List<HlModel> list = res.isNotEmpty
        ? res.map((tableName) => HlModel.fromJson(tableName)).toList()
        : [];

    return list;
  }
}
