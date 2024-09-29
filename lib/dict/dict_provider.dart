import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:bibliasacra/utils/utils_constants.dart';
import 'package:sqflite/sqflite.dart';

// dict_provider.dart

class DicProvider {
  final String dataBaseName = Constants.dictDbname;

  DicProvider.internal();
  static final DicProvider _instance = DicProvider.internal();
  static Database? _database;

  factory DicProvider() => _instance;

  Future<Database> get database async {
    _database ??= await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, dataBaseName);

    if (!await databaseExists(path)) {

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(join("assets/dict", dataBaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(path).writeAsBytes(bytes, flush: true);

    }

    Database db = await openDatabase(path);
    return db;
  }

  Future close() async {
    return _database!.close();
  }
}
