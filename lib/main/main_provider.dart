import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// main_provider.dart

late String dataBaseName;

class DbProvider {
  String dbName = '';
  static String? dataBaseName;
  static DbProvider? _dbProvider;
  static Database? _database;

  DbProvider._createInstance();

  DbProvider(this.dbName) {
    dataBaseName = dbName;
    _dbProvider ??= DbProvider._createInstance();
  }

  Future<Database> get database async {
    //_database ??= await initDB();
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);

    if (!await databaseExists(path)) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(join("assets/bibles", dataBaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    }

    return await databaseFactory.openDatabase(path);
  }

  Future close() async {
    return _database!.close();
  }
}
