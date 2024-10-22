import 'dart:async';
import 'package:bibliasacra/vers/vers_provider.dart';
import 'package:bibliasacra/vers/vers_model.dart';
import 'package:sqflite/sqflite.dart';

// Version Key

VkProvider? _vkProvider;

class VkQueries {
  final String tableName = 'version_key';

  VkQueries() {
    _vkProvider = VkProvider();
  }

  Future<int?> getActiveVersionCount() async {
    final db = await _vkProvider!.database;
    return Sqflite.firstIntValue(await db
        .rawQuery('''SELECT COUNT(*) FROM $tableName WHERE active=?''', ['1']));
  }

  Future<void> updateActiveState(int a, int i) async {
    final db = await _vkProvider!.database;
    await db
        .rawUpdate('''UPDATE $tableName SET active=? WHERE number=?''', [a, i]);
  }

  Future<List<VkModel>> getAllVersions(int bibleVersion) async {
    final db = await _vkProvider!.database;

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE number <> ?''', [bibleVersion]);

    List<VkModel> list = res.isNotEmpty
        ? res.map((tableName) => VkModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List> getActiveVersionNumbers(int bibleVersion) async {
    final db = await _vkProvider!.database;

    final List values = await db.rawQuery(
        '''SELECT number,abbr,lang FROM $tableName WHERE active=1 ORDER BY number=? DESC''',
        ['$bibleVersion']);
    return values;
  }

  Future<List<VkModel>> getActiveVersions(int bibleVersion) async {
    final db = await _vkProvider!.database;

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE active=? and number <> ?''',
        ['1', bibleVersion]);

    List<VkModel> list = res.isNotEmpty
        ? res.map((tableName) => VkModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List<VkModel>> getVersionKey(int n) async {
    final db = await _vkProvider!.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName WHERE number=?''', [n]);

    List<VkModel> list = res.isNotEmpty
        ? res.map((tableName) => VkModel.fromJson(tableName)).toList()
        : [];

    return list;
  }
}
