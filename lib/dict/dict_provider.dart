import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';

// dict_provider.dart

class DicProvider {
  final int newDbVersion = 1;
  final String dataBaseName = Constants.dictDbname;

  DicProvider();

  DicProvider.internal();
  static final DicProvider _instance = DicProvider.internal();
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dataBaseName);

    Database db = await openDatabase(path);

    // not exists returns zero
    if (await db.getVersion() < newDbVersion) {
      db.close();
      await deleteDatabase(path);

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets/dict", dataBaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);

      db = await openDatabase(path);

      db.setVersion(newDbVersion);
    }
    return db;
  }

  Future close() async {
    return _database!.close();
  }
}
