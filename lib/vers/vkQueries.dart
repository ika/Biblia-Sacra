import 'dart:async';
import 'package:bibliasacra/globals/globals.dart';
import 'package:bibliasacra/vers/vkProvider.dart';
import 'package:bibliasacra/vers/vkModel.dart';
import 'package:sqflite/sqflite.dart';

// Version Key

VkProvider _vkProvider;

class VkQueries {
  final String tableName = 'version_key';

  VkQueries() {
    _vkProvider = VkProvider();
  }

  Future<int> getActiveVersionCount() async {
    final db = await _vkProvider.database;
    int count = Sqflite.firstIntValue(await db.rawQuery(
        '''SELECT COUNT(*) FROM $tableName WHERE active=?''',
        ['1']));
    return count;
  }

  Future<void> updateActiveState(int a, int i) async {
    final db = await _vkProvider.database;
    await db
        .rawUpdate('''UPDATE $tableName SET active=? WHERE number=?''', [a, i]);
  }

  Future<List<VkModel>> getAllVersions() async {
    final db = await _vkProvider.database;

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE number <> ?''',
        [Globals.bibleVersion]);

    List<VkModel> list = res.isNotEmpty
        ? res.map((tableName) => VkModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List> getActiveVersionNumbers() async {
    final db = await _vkProvider.database;

    final List values = await db.rawQuery(
        '''SELECT number,abbr,lang FROM $tableName WHERE active=?''',
        ['1']);
    return values;
  }

  Future<List<VkModel>> getActiveVersions() async {
    final db = await _vkProvider.database;

    var res = await db.rawQuery(
        '''SELECT * FROM $tableName WHERE active=? and number <> ?''',
        ['1', Globals.bibleVersion]);

    List<VkModel> list = res.isNotEmpty
        ? res.map((tableName) => VkModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List<VkModel>> getVersionKey(int n) async {
    final db = await _vkProvider.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName WHERE number=?''', [n]);

    List<VkModel> list = res.isNotEmpty
        ? res.map((tableName) => VkModel.fromJson(tableName)).toList()
        : [];

    return list;
  }
}
