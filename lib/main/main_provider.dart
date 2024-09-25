import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// main_provider.dart

class DbProvider {
  final int newDbVersion = 1;
  late String dataBaseName;

  DbProvider(dbName) {
    dataBaseName = dbName;
  }

  DbProvider.internal();
  static final DbProvider instance = DbProvider.internal();
  static Database? _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dataBaseName);

    Database db = await openDatabase(path);

    if (await db.getVersion() < newDbVersion) {
      db.close();
      await deleteDatabase(path);

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(join("assets/bibles", dataBaseName));
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
