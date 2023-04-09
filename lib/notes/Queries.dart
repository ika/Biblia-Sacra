import 'package:bibliasacra/notes/Model.dart';
import 'package:bibliasacra/notes/Provider.dart';

NtProvider _ntProvider;

class NtQueries {
  final String tableName = 'notes';

  NtQueries() {
    _ntProvider = NtProvider();
  }

  Future<int> insertNote(NtModel model) async {
    final db = await _ntProvider.database;

    return await db.insert(tableName, model.toJson());
  }

  Future<int> updateNote(NtModel model) async {
    final db = await _ntProvider.database;

    return await db.update(tableName, model.toJson(),
        where: 'id=?', whereArgs: [model.id]);
  }

  Future<List<NtModel>> getAllVersionNotes(int v) async {
    final db = await _ntProvider.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName WHERE version=?''', [v]);

    List<NtModel> list = res.isNotEmpty
        ? res.map((tableName) => NtModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

    Future<List<NtModel>> getAllNotes() async {
    final db = await _ntProvider.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName ORDER BY id DESC''');

    List<NtModel> list = res.isNotEmpty
        ? res.map((tableName) => NtModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<List<NtModel>> getNoteByBid(int bid) async {
    final db = await _ntProvider.database;

    var res =
        await db.rawQuery('''SELECT * FROM $tableName WHERE bid=?''', [bid]);

    List<NtModel> list = res.isNotEmpty
        ? res.map((tableName) => NtModel.fromJson(tableName)).toList()
        : [];

    return list;
  }

  Future<int> deleteNote(int id) async {
    final db = await _ntProvider.database;

    return await db.rawDelete('''DELETE FROM $tableName WHERE id=?''', [id]);
  }

  // Future<int> getNoteCount() async {
  //   final db = await _ntProvider.database;

  //   return Sqflite.firstIntValue(
  //       await db.rawQuery('''SELECT COUNT(*) FROM $tableName'''));
  // }
}
