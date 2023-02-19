

import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:bibliasacra/utils/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DicProvider {
  final String dataBaseName = Constants.dictDbname;

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
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);

    if (!(await databaseExists(path))) {
      try {
        await io.Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets/bibles", dataBaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await io.File(path).writeAsBytes(bytes, flush: true);
    }
    return await openDatabase(path, version: 1);
    //return await databaseFactory.openDatabase(path);
  }

  Future close() async {
    return _db.close();
  }
}
