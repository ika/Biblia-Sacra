

import 'dart:io';
import 'package:bibliasacra/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DicProvider {
  final String _dbName = Constants.dictDbname;

  static final DicProvider _instance = DicProvider.internal();

  factory DicProvider() {
    return _instance;
  }

  static dynamic _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  DicProvider.internal();

  initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, _dbName);

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(p.dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(p.join("assets", _dbName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path, version: 1);
  }

  Future close() async {
    return _db.close();
  }
}
