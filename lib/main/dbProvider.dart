import 'dart:async';
import 'dart:io' as io;
import 'package:bibliasacra/globals/globals.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:bibliasacra/utils/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

String dataBaseName = '';

String getBVFileName(int v) {
  String dbName = '';
  switch (v) {
    case 1:
      dbName = Constants.kjvbDbname;
      break;
    case 2:
      dbName = Constants.clemDbname;
      break;
    case 3:
      dbName = Constants.cpdvDbname;
      break;
    case 4:
      dbName = Constants.nvulDbname;
      break;
    case 5:
    // _dbName = Constants.af53Dbname;
    // break;
    case 6:
    // _dbName = Constants.dn33Dbname;
    // break;
    case 7:
      dbName = Constants.ukjvDbname;
      break;
    case 8:
      dbName = Constants.webbDbname;
      break;
    // case 9:
    //   dbName = Constants.af83Dbname;
    //   break;
    case 10:
      dbName = Constants.asvbDbname;
      break;
  }
  return dbName;
}

class DbProvider {
  static String dataBaseName;
  static DbProvider _dbProvider;
  static Database _database;

  DbProvider._createInstance();

  factory DbProvider() {
    dataBaseName = getBVFileName(Globals.bibleVersion);

    _dbProvider ??= DbProvider._createInstance();
    return _dbProvider;
  }

  Future<Database> get database async {
    //_database ??= await initDB();
    _database = await initDB();
    return _database;
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
    return _database.close();
  }
}
