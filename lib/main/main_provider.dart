import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// main_provider.dart

class DbProvider {
  late String dataBaseName;

  DbProvider(dbName) {
    dataBaseName = dbName;
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
    String path = join(databasesPath, dataBaseName);

    late Database db;

    bool exists = await databaseExists(path);

    if (!exists) {

      //debugPrint("DATABASE NOT EXISTS $dataBaseName");
      
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(join("assets/bibles", dataBaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      
      await Future.delayed(const Duration(milliseconds: 500));
    }

    db = await openDatabase(path, readOnly: true);

    return db;
  }

  Future close() async {
    return _database!.close();
  }
}
