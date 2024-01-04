import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, dataBaseName);

    if (!await databaseExists(path)) {
      try {
        await io.Directory(p.dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data =
          await rootBundle.load(p.join("assets/bibles", dataBaseName));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await io.File(path).writeAsBytes(bytes, flush: true);
    }

    return await databaseFactory.openDatabase(path);
  }

  Future close() async {
    return _database!.close();
  }
}
