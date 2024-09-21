import 'dart:async';
import 'package:bibliasacra/high/hl_model.dart';
import 'package:bibliasacra/high/hl_provider.dart';
import 'package:sqflite/sqflite.dart';

// hi_queries.dart

HlProvider? _hlProvider;

class HlQueries {
  final String tableName = 'hlts_table';

  HlQueries() {
    _hlProvider = HlProvider();
  }

  Future<int> saveHighLight(HlModel model) async {
    final db = await _hlProvider!.database;
    return await db.insert(
      tableName,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteHighLight(int bid) async {
    final db = await _hlProvider!.database;
    return await db.rawDelete('''DELETE FROM $tableName WHERE bid=?''', [bid]);
  }

  Future<List<HlModel>> getHighLightList() async {
    final db = await _hlProvider!.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName ORDER BY id DESC''');

    List<HlModel> list = res.isNotEmpty
        ? res.map((tableName) => HlModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List<HlModel>> getHighVersionList(int v) async {
    final db = await _hlProvider!.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName WHERE version=?''', [v]);

    List<HlModel> list = res.isNotEmpty
        ? res.map((tableName) => HlModel.fromJson(tableName)).toList()
        : [];

    return list;
  }
}
