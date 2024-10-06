import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bibliasacra/utils/utils_constants.dart';

// main_provider.dart

late int newDbVersion;

class DbProvider {
  late String dataBaseName;

  DbProvider(dbName) {
    dataBaseName = dbName;

    switch (dataBaseName) {
      case Constants.kjvbDbname:
        newDbVersion = 2;
        break;
      case Constants.ukjvDbname:
        newDbVersion = 2;
        break;
      case Constants.clemDbname:
        newDbVersion = 2;
        break;
      case Constants.cpdvDbname:
        newDbVersion = 2;
        break;
      case Constants.nvulDbname:
        newDbVersion = 2;
        break;
      case Constants.webbDbname:
        newDbVersion = 2;
        break;
      case Constants.asvbDbname:
        newDbVersion = 2;
        break;
      default:
        newDbVersion = 2;
    }
  }

  DbProvider.internal();
  static final DbProvider instance = DbProvider.internal();
  static Database? _database;

  //factory DbProvider() => _instance;

  Future<Database> get database async {
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path =join(databasesPath, dataBaseName);

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
